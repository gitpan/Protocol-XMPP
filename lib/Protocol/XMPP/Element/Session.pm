package Protocol::XMPP::Element::Session;
BEGIN {
  $Protocol::XMPP::Element::Session::VERSION = '0.004';
}
use strict;
use warnings FATAL => 'all';
use parent qw(Protocol::XMPP::ElementBase);

=head1 NAME

Protocol::XMPP::Bind - register ability to deal with a specific feature

=head1 VERSION

version 0.004

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 METHODS

=cut

=head2 end_element

=cut

sub end_element {
	my $self = shift;
	return unless $self->parent->isa('Protocol::XMPP::Element::Features');

	$self->debug("Had session request");
	$self->write_xml(['iq', 'type' => 'set', id => $self->next_id, _content => [[ 'session', '_ns' => 'xmpp-session' ]] ]);
}

1;

__END__

=head1 AUTHOR

Tom Molesworth <cpan@entitymodel.com>

=head1 LICENSE

Copyright Tom Molesworth 2010-2011. Licensed under the same terms as Perl itself.