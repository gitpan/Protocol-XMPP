package Protocol::XMPP::Element::JID;
use strict;
use warnings FATAL => 'all';
use 5.10.0;
use parent qw(Protocol::XMPP::TextElement);

=head1 NAME

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 METHODS

=cut

sub on_text_complete {
	my $self = shift;
	my $data = shift;
	$self->{jid} = $data;
	$self->debug("Full JID was [$data]");
	# $self->stream->queue_write(q{<iq type='set' id='purple9921ba3c'><session xmlns='urn:ietf:params:xml:ns:xmpp-session'/></iq>});
	# $self->write_xml([ 'iq', type => 'set', id => 'xyz', _content => [ [ 'session', _ns => 'xmpp-session' ] ] ]);
}

1;
