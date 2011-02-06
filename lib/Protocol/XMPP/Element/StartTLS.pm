package Protocol::XMPP::Element::StartTLS;
BEGIN {
  $Protocol::XMPP::Element::StartTLS::VERSION = '0.002';
}
use strict;
use warnings FATAL => 'all';
use 5.010;
use parent qw(Protocol::XMPP::ElementBase);

=head1 NAME

=head1 SYNOPSIS

=head1 VERSION

version 0.002

=head1 DESCRIPTION

=head1 METHODS

=cut

sub end_element {
	my $self = shift;
	$self->debug('TLS available');
	$self->stream->{features}->{tls} = 1;
	$self->stream->{tls_pending} = 1;

# screw this, let's go straight into TLS mode
	$self->write_xml(['starttls', _ns => 'xmpp-tls']);
	$self;
}

1;