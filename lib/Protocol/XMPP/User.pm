package Protocol::XMPP::User;
BEGIN {
  $Protocol::XMPP::User::VERSION = '0.003';
}
use strict;
use warnings FATAL => 'all';

use Protocol::XMPP::Roster;

sub new {
	my $class = shift;
	my $self = bless { }, $class;
	return $self;
}

sub name {

}

sub roster {
	my $self = shift;
	return Protocol::XMPP::Roster->new($self);
}

1;
