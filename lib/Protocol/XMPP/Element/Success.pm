package Protocol::XMPP::Element::Success;
use strict;
use warnings FATAL => 'all';
use 5.10.0;
use parent qw(Protocol::XMPP::ElementBase);

=head1 NAME

Protocol::XMPP::Success - indicate success for an operation

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 METHODS

=cut

sub end_element {
	my $self = shift;
	$self->debug("Successful response");
	$self->stream->reset;
	$self->write_text(@{$self->stream->preamble});
	$self->is_authorised(1);
}

1;
