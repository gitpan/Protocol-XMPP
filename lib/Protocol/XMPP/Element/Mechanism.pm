package Protocol::XMPP::Element::Mechanism;
BEGIN {
  $Protocol::XMPP::Element::Mechanism::VERSION = '0.003';
}
use strict;
use warnings FATAL => 'all';
use parent qw(Protocol::XMPP::TextElement);

=head1 NAME

Protocol::XMPP::Mechanism - information on available auth mechanisms

=head1 VERSION

version 0.003

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 METHODS

=cut


=head2 C<on_text_complete>

Set L<type> based on the text data.

=cut

sub on_text_complete {
	my $self = shift;
	my $data = shift;
	$self->type = $data;
	return $self;
}
	
=head2 C<type>

Mechanism type.

=cut

sub type : lvalue { shift->{type} }

=head2 C<end_element>

=cut

sub end_element {
	my $self = shift;
	$self->SUPER::end_element(@_);

	$self->parent->add_mechanism($self);
	$self;
}

1;