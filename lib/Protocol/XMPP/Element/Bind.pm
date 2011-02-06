package Protocol::XMPP::Element::Bind;
BEGIN {
  $Protocol::XMPP::Element::Bind::VERSION = '0.003';
}
use strict;
use warnings FATAL => 'all';
use parent qw(Protocol::XMPP::ElementBase);

=head1 NAME

Protocol::XMPP::Bind - register ability to deal with a specific feature

=head1 VERSION

version 0.003

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 METHODS

=cut

=head2 C<end_element>

=cut

sub end_element {
	my $self = shift;
	return unless $self->parent->isa('Protocol::XMPP::Element::Features');

	$self->debug("Had bind request");
	$self->write_xml(['iq', 'type' => 'set', id => $self->next_id, _content => [[ 'bind', '_ns' => 'xmpp-bind' ]] ]);
}

1;