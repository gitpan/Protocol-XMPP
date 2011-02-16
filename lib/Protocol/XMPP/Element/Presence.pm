package Protocol::XMPP::Element::Presence;
BEGIN {
  $Protocol::XMPP::Element::Presence::VERSION = '0.004';
}
use strict;
use warnings FATAL => 'all';
use parent qw(Protocol::XMPP::ElementBase);

use Protocol::XMPP::Contact;

=head1 NAME

Protocol::XMPP::Success - indicate success for an operation

=head1 VERSION

version 0.004

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 METHODS

=cut

sub end_element {
	my $self = shift;
	$self->debug("Had presence information");
	my $attr = $self->attributes;
	my $contact = Protocol::XMPP::Contact->new(
		stream	=> $self->stream,
		jid	=> $attr->{from},
	);
	$self->dispatch_event('presence', $contact);
}

1;

__END__

=head1 AUTHOR

Tom Molesworth <cpan@entitymodel.com>

=head1 LICENSE

Copyright Tom Molesworth 2010-2011. Licensed under the same terms as Perl itself.