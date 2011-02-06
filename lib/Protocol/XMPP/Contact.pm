package Protocol::XMPP::Contact;
BEGIN {
  $Protocol::XMPP::Contact::VERSION = '0.003';
}
use strict;
use warnings FATAL => 'all';
use parent qw{Protocol::XMPP::Base};

=head1 NAME

Protocol::XMPP::Stream - handle XMPP protocol stream

=head1 VERSION

version 0.003

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 METHODS

=cut

sub jid { shift->{jid} }
sub name { my $self = shift; defined($self->{name}) ? $self->{name} : $self->{jid} }

sub is_me {
	my $self = shift;
	return $self->jid eq $self->stream->jid;
}

=head2 C<authorise>

Authorise a contact by sending a 'subscribed' presence response.

=cut

sub authorise {
	my $self = shift;
	$self->write_xml(['presence', from => $self->stream->jid, to => $self->jid, type => 'subscribed']);
}

=head2 C<subscribe>

Request subscription for a contact by sending a 'subscribe' presence response.

=cut

sub subscribe {
	my $self = shift;
	$self->write_xml(['presence', from => $self->stream->jid, to => $self->jid, type => 'subscribe']);
}

=head2 C<unsubscribe>

Reject or unsubscribe a contact by sending an 'unsubscribed' presence response.

=cut

sub unsubscribe {
	my $self = shift;
	$self->write_xml(['presence', from => $self->stream->jid, to => $self->jid, type => 'unsubscribed']);
}

1;