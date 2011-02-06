package Protocol::XMPP::Base;
BEGIN {
  $Protocol::XMPP::Base::VERSION = '0.003';
}
use strict;
use warnings FATAL => 'all';

use Scalar::Util ();

# For debug messages
use Time::HiRes qw{time};
use POSIX qw{strftime};

=head1 NAME

Protocol::XMPP::Base - base class for L<Protocol::XMPP>

=head1 VERSION

version 0.003

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 METHODS

=cut

=head2 new

Constructor. Stores all parameters on $self, including the top level stack item as L<parent>.

=cut

sub new {
	my $class = shift;
	return bless { @_ }, $class;
}

=head2 debug

Helper method for displaying a debug message. Only displayed if the debug flag was passed to L<configure>.

=cut

sub debug {
	my $self = shift;
	return unless $self->stream->{debug};

	my $now = Time::HiRes::time;
	warn strftime("%Y-%m-%d %H:%M:%S", gmtime($now)) . sprintf(".%03d", int($now * 1000.0) % 1000.0) . " @_\n";
	return $self;
}

=head2 _ref_to_xml

Convert an arrayref to an XML fragment.

Input such as the following:

 [ 'iq', type => 'set', id => 'xyz', _content => [ [ 'session', _ns => 'xmpp-session' ] ] ]

would be converted to:

 <iq type=>'set' id=>'xyz'><session xmlns='...:xmpp-session'/></iq>

=cut

sub _ref_to_xml {
	my $self = shift;
	my $ref = shift;
	my ($element, %attr) = @$ref;
	$attr{xmlns} = 'urn:ietf:params:xml:ns:' . delete($attr{_ns}) if $attr{_ns};
	my $unterm = delete $attr{_unterminated};
	my $content = delete $attr{_content};
	my $str = '<' . join(' ', $element, map { $_ . "='" . $attr{$_} . "'" } sort keys %attr);
	if(ref $content) {
		$str .= '>';
		$str .= $self->_ref_to_xml($_) foreach @$content;
		$str .= "</$element>" unless $unterm;
	} elsif(defined $content) {
		$str .= '>';
		$str .= $content;
		$str .= "</$element>" unless $unterm;
	} else {
		$str .= $unterm ? '>' : '/>';
	}
	return $str;
}

=head1 PROXY METHODS

The following methods are proxied to the L<Protocol::XMPP::Stream> class via L<stream>.

=cut

=head2 is_loggedin

Accessor for the loggedin state - will call the appropriate on_(login|logout) event when
changing state.

=cut

sub is_loggedin {
	my $self = shift;
	return $self->stream->is_loggedin(@_);
}

sub is_authorised {
	my $self = shift;
	return $self->stream->is_authorised(@_);
}

=head2 write_xml

Write XML reference to stream.

=cut

sub write_xml {
	my $self = shift;
	return $self->stream->write_xml(@_);
}

=head2 write_text

Write XML reference to stream.

=cut

sub write_text {
	my $self = shift;
	return $self->stream->write_text(@_);
}

sub dispatch_event {
	my $self = shift;
	return $self->stream->dispatch_event(@_);
}


=head2 C<stream>

Returns the active L<Protocol::XMPP::Stream> object.

=cut

sub stream {
	my $self = shift;
	if(@_) {
		my $stream = shift;
		Scalar::Util::weaken $stream;
		$self->{stream} = $stream;
		return $self;
	}
	return $self->{stream};
}

sub next_id {
	my $self = shift;
	return $self->stream->next_id(@_);
}

1;