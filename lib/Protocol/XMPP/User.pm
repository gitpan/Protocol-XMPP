package Protocol::XMPP::User;
use strict;
use warnings FATAL => 'all';
use 5.10.0;

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
