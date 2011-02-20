package Protocol::XMPP::Element::Mechanisms;
BEGIN {
  $Protocol::XMPP::Element::Mechanisms::VERSION = '0.005';
}
use strict;
use warnings FATAL => 'all';
use parent qw(Protocol::XMPP::ElementBase);

=head1 NAME

=head1 SYNOPSIS

=head1 VERSION

version 0.005

=head1 DESCRIPTION

=head1 METHODS

=cut

sub add_mechanism {
	my $self = shift;
	my $mech = shift;
	push @{ $self->{mechanism} }, $mech;
	$self;
}

sub end_element {
	my $self = shift;
	$self->debug("Supported auth mechanisms: " . join(' ', map { $_->type } @{$self->{mechanism}}));
	$self->parent->{mechanism} = $self->{mechanism} if $self->parent;
	$self;
}

1;

__END__

=head1 AUTHOR

Tom Molesworth <cpan@entitymodel.com>

=head1 LICENSE

Copyright Tom Molesworth 2010-2011. Licensed under the same terms as Perl itself.