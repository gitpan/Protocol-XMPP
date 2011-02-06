package Protocol::XMPP::Element::Proceed;
BEGIN {
  $Protocol::XMPP::Element::Proceed::VERSION = '0.002';
}
use strict;
use warnings FATAL => 'all';
use 5.010;
use parent qw(Protocol::XMPP::ElementBase);

=head1 NAME

=head1 SYNOPSIS

=head1 VERSION

version 0.002

=head1 DESCRIPTION

=head1 METHODS

=cut

sub end_element {
	my $self = shift;
	$self->dispatch_event('starttls');
	$self;
}

1;