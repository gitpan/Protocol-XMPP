package Protocol::XMPP::Element::Body;
use strict;
use warnings FATAL => 'all';
use parent qw(Protocol::XMPP::ElementBase);

=head1 NAME

Protocol::XMPP::Feature - register ability to deal with a specific feature

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 METHODS

=cut

=head2 C<end_element>

=cut

sub end_element {
	my $self = shift;
	return unless $self->parent->isa('Protocol::XMPP::Element::Message');

	$self->parent->{body} = $self->{data};
	$self->debug("Body was " . $self->{data});
}

1;
