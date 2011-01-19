package Protocol::XMPP::TextElement;
use strict;
use warnings FATAL => 'all';
use 5.10.0;
use parent qw(Protocol::XMPP::ElementBase);

=head1 NAME

Protocol::XMPP::TextElement - 

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 METHODS

=cut

sub new { my $class = shift; my $self = $class->SUPER::new(@_); $self->{text_data} = ''; $self }

=head2 C<characters>

=cut

sub characters {
	my $self = shift;
	my $v = shift;
	$self->{text_data} .= $v;
	$self;
}

sub trim { $_[0] =~ s/(?:^\s*)|(?:\s*$)//g; $_[0] }

=head2 C<end_element>

=cut

sub end_element {
	my $self = shift;
	my $data = trim($self->{text_data});
	$self->on_text_complete($data);
	$self;
}

1;
