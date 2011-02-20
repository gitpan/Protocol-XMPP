package Protocol::XMPP::Element::Register;
BEGIN {
  $Protocol::XMPP::Element::Register::VERSION = '0.005';
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

use Data::Dumper;

sub new {
	my $class = shift;
	my $self = $class->SUPER::new(@_);
	$self->debug($self->{element}->{NamespaceURI});
	$self;
}

sub end_element {
	my $self = shift;
	$self->debug("Register request received, data was: " . $self->{data});
	$self;
}

1;

__END__

=head1 AUTHOR

Tom Molesworth <cpan@entitymodel.com>

=head1 LICENSE

Copyright Tom Molesworth 2010-2011. Licensed under the same terms as Perl itself.