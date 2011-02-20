package Protocol::XMPP::ElementBase;
BEGIN {
  $Protocol::XMPP::ElementBase::VERSION = '0.005';
}
use strict;
use warnings FATAL => 'all';
use parent qw{Protocol::XMPP::Base};

=head1 NAME

Protocol::XMPP::ElementBase - base class for L<Protocol::XMPP> XML fragment handling

=head1 VERSION

version 0.005

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 METHODS

=cut

sub new {
	my $class = shift;
	my $self = $class->SUPER::new(@_);
	$self->{data} = '';
	return $self;
}

=head2 attributes

Access the XML element attributes as key-value pairs.

=cut

sub attributes {
	my $self = shift;
	return {
		map { $_->{LocalName} => $_->{Value} } values %{$self->{element}->{Attributes}}
	};
}

=head2 parent

Accessor for the parent object, if available.

=cut

sub parent { shift->{parent} }

=head2 characters

Called when new character data is available. Appends to internal buffer.

=cut

sub characters {
	my $self = shift;
	my $data = shift;
	$self->{data} .= $data;
	$self;
}

=head2 end_element

Called when an XML element is terminated.

=cut

sub end_element {
	my $self = shift;
	$self->debug("Virtual end_element for $_[0]");
}

1;

__END__

=head1 AUTHOR

Tom Molesworth <cpan@entitymodel.com>

=head1 LICENSE

Copyright Tom Molesworth 2010-2011. Licensed under the same terms as Perl itself.