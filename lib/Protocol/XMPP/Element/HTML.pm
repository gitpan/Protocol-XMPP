package Protocol::XMPP::Element::HTML;
BEGIN {
  $Protocol::XMPP::Element::HTML::VERSION = '0.003';
}
use strict;
use warnings FATAL => 'all';
use parent qw(Protocol::XMPP::ElementBase);

=head1 NAME

Protocol::XMPP::Feature - register ability to deal with a specific feature

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
	$self->debug("Ignoring HTML content");
}

1;