package Protocol::XMPP::Element::JID;
BEGIN {
  $Protocol::XMPP::Element::JID::VERSION = '0.005';
}
use strict;
use warnings FATAL => 'all';
use parent qw(Protocol::XMPP::TextElement);

=head1 NAME

=head1 SYNOPSIS

=head1 VERSION

version 0.005

=head1 DESCRIPTION

=head1 METHODS

=cut

sub on_text_complete {
	my $self = shift;
	my $data = shift;
	$self->{jid} = $data;
	$self->stream->jid($data);
	$self->debug("Full JID was [$data]");
}

1;

__END__

=head1 AUTHOR

Tom Molesworth <cpan@entitymodel.com>

=head1 LICENSE

Copyright Tom Molesworth 2010-2011. Licensed under the same terms as Perl itself.