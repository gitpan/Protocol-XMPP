package Protocol::XMPP::Stream;
BEGIN {
  $Protocol::XMPP::Stream::VERSION = '0.002';
}
use strict;
use warnings FATAL => 'all';
use parent qw{Protocol::XMPP::Base};

=head1 NAME

Protocol::XMPP::Stream - handle XMPP protocol stream

=head1 VERSION

version 0.002

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 METHODS

=cut

use XML::SAX;
use XML::LibXML::SAX::ChunkParser;
use Protocol::XMPP::Handler;
use Protocol::XMPP::Message;
use Authen::SASL;

=head2 new

=cut

sub new {
	my $class = shift;
	my %args = @_;

	my $self = bless { }, $class;
	foreach (qw{on_queued_write on_starttls user pass}) {
		$self->{$_} = $args{$_} if exists $args{$_};
	}
	$self->{debug} = 1;
	$self->reset;
	$self->{write_buffer} = [];
	$self;
}

=head2 on_data

Data has been received, pass it over to the SAX parser to trigger any required events.

=cut

sub on_data {
	my $self = shift;
	my $data = shift;
	return $self unless length $data;

	$self->debug("<<< $data");
	$self->{sax}->parse_chunk($data);
	return $self;
}

=head2 queue_write

Queue up a write for this stream. Adds to the existing send buffer array if there is one.

When a write is queued, this will send a notification to the on_queued_write callback if one
was defined.

=cut

sub queue_write {
	my $self = shift;
	my $v = shift;
	$self->debug("Queued a write for [$v]");
	push @{$self->{write_buffer}}, $v;
	$self->{on_queued_write}->() if $self->{on_queued_write};
	return $self;
}

=head2 write_buffer

Returns the contents of the current write buffer without changing it.

=cut

sub write_buffer { shift->{write_buffer} }

=head2 extract_write

Retrieves next pending message from the write buffer and removes it from the list.

=cut

sub extract_write {
	my $self = shift;
	return unless @{$self->{write_buffer}};
	my $v = shift @{$self->{write_buffer}};
	$self->debug("Extract write [$v]");
	return $v;
}

=head2 ready_to_send

Returns true if there's data ready to be written.

=cut

sub ready_to_send {
	my $self = shift;
	$self->debug('Check whether ready to send, current length '. @{$self->{write_buffer}});
	return @{$self->{write_buffer}};
}

=head2 reset

Reset this stream.

Clears out the existing SAX parsing information and sets up a new L<Protocol::XMPP::Handler> ready to accept
events. Used when we expect a new C<<stream>> element, for example after authentication or TLS upgrade.

=cut

sub reset {
	my $self = shift;
	$self->debug('Reset stream');
	my $handler = Protocol::XMPP::Handler->new(
		stream => $self		# this will be converted to a weak ref to self...
	);
	$self->{handler} = $handler;	# ... but we keep a strong ref to the handler since we control it

	# We need to be able to handle document fragments, so we specify a SAX parser here.
	# TODO If ChunkParser advertised fragment handling as a feature we could require that
	# rather than hardcoding the parser type here.
	{
		local $XML::SAX::ParserPackage = 'XML::LibXML::SAX::ChunkParser';
		$self->{sax} = XML::SAX::ParserFactory->parser(Handler => $self->{handler}) or die "No SAX parser could be found";
	};
	$self->{data} = '';
	return $self;
}

=head2 C<dispatch_event>

Call the appropriate event handler.

Currently defined events:

=over 4

=item * features - we have received the features list from the server

=item * login - login was completed successfully

=item * message - a message was received

=item * presence - a presence notification was received

=item * subscription - a presence notification was received

=item * transfer_request - a file transfer request has been received

=item * file - a file was received

=back

=cut

sub dispatch_event {
	my $self = shift;
	my $type = shift;
	my $method = 'on_' . $type;
	my $sub = $self->{$method} || $self->can($method);
	return $sub->($self, @_) if $sub;
	$self->debug("No method found for $method");
}

=head2 preamble

Returns the XML header and opening stream preamble.

=cut

sub preamble {
	my $self = shift;
	# TODO yeah fix this
	return [
		qq{<?xml version='1.0' ?>},
		q{<stream:stream to='} . $self->hostname . q{' xmlns='jabber:client' xmlns:stream='http://etherx.jabber.org/streams' version='1.0'>}
	];
}

=head2 jid

=cut

sub jid {
	my $self = shift;
	if(@_) {
		$self->{jid} = shift;
		($self->{user}, $self->{hostname}) = split /\@/, $self->{jid}, 2;
		return $self;
	}
	return $self->{jid};
}

=head2 user

Username for SASL authentication.

=cut

sub user { shift->{user} }

=head2 pass

Password for SASL authentication.

=cut

sub pass { shift->{pass} }

=head2 hostname

Name of the host

=cut

sub hostname { shift->{hostname} }

=head2 C<write_xml>

Write a chunk of XML to the stream, converting from the internal representation to XML
text stanzas.

=cut

sub write_xml {
	my $self = shift;
	$self->queue_write($self->_ref_to_xml(@_));
}

=head2 C<write_text>

Write raw text to the output stream.

=cut

sub write_text {
	my $self = shift;
	$self->queue_write($_) for @_;
}

sub login {
	my $self = shift;
	my %args = @_;

	my $user = delete $args{user} || $self->user;
	my $pass = delete $args{password} || $self->pass;

	my $sasl = Authen::SASL->new(
		mechanism => $self->{features}->_sasl_mechanism_list,
		callback => {
# TODO Convert these to plain values or sapped entries
			pass => sub { $pass },
			user => sub { $user },
			authname => sub { warn @_; }
		}
	);

# TODO localhost isn't always the right answer here
	my $s = $sasl->client_new(
		'xmpp',
		$self->hostname,
		0
	);
	$self->{features}->{sasl_client} = $s;

	my $mech = $s->mechanism;
	$self->debug("SASL mechanism: " . $mech);
	$self->queue_write($self->_ref_to_xml(['auth', '_ns' => 'xmpp-sasl', mechanism => $mech ]));
	return $self;
}

sub is_authorised {
	my $self = shift;
	if(@_) {
		my $state = shift;
		$self->{authorised} = $state;
		$self->dispatch_event($state ? 'authorised' : 'unauthorised');
		return $self;
	}
	return $self->{authorised};
}

sub is_loggedin {
	my $self = shift;
	if(@_) {
		my $state = shift;
		$self->{loggedin} = $state;
		$self->dispatch_event($state ? 'login' : 'logout');
		return $self;
	}
	return $self->{loggedin};
}

=head2 C<stream>

Override the ->stream method from the base class so that we pick up our own methods directly.

=cut

sub stream { shift }

sub next_id {
	my $self = shift;
	unless($self->{request_id}) {
		$self->{request_id} = 'pxa0001';
	}
	return $self->{request_id}++;
}

sub on_tls_complete {
	my $self = shift;
	delete $self->{tls_pending};
	$self->reset;
	$self->write_text($_) for @{$self->preamble};
}

sub compose {
	my $self = shift;
	my %args = @_;
	return Protocol::XMPP::Message->new(	
		stream	=> $self,
		from	=> $self->jid,
		%args
	);
}

sub subscribe {
	my $self = shift;
	my $to = shift;
	Protocol::XMPP::Contact->new(	
		stream	=> $self,
		jid	=> $to,
	)->subscribe;
}

sub unsubscribe {
	my $self = shift;
	my $to = shift;
	Protocol::XMPP::Contact->new(	
		stream	=> $self,
		jid	=> $to,
	)->unsubscribe;
}

sub authorise {
	my $self = shift;
	my $to = shift;
	Protocol::XMPP::Contact->new(	
		stream	=> $self,
		jid	=> $to,
	)->authorise;
}

sub deauthorise {
	my $self = shift;
	my $to = shift;
	Protocol::XMPP::Contact->new(	
		stream	=> $self,
		jid	=> $to,
	)->deauthorise;
}

1;