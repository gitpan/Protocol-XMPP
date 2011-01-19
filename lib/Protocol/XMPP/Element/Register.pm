package Protocol::XMPP::Element::Register;
use strict;
use warnings FATAL => 'all';
use 5.10.0;
use parent qw(Protocol::XMPP::ElementBase);

=head1 NAME

=head1 SYNOPSIS

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
