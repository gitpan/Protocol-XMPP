package Protocol::XMPP::Element::Session;
use strict;
use warnings FATAL => 'all';
use parent qw(Protocol::XMPP::ElementBase);

=head1 NAME

Protocol::XMPP::Bind - register ability to deal with a specific feature

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 METHODS

=cut

=head2 C<end_element>

=cut

sub end_element {
	my $self = shift;
	return unless $self->parent->isa('Protocol::XMPP::Element::Features');

	$self->debug("Had session request");
	$self->write_xml(['iq', 'type' => 'set', id => $self->next_id, _content => [[ 'session', '_ns' => 'xmpp-session' ]] ]);
}

1;
