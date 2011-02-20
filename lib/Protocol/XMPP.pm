package Protocol::XMPP;
# ABSTRACT: XMPP/Jabber protocol API
use strict;
use warnings;

our $VERSION = '0.005';

# This package merely imports all necessary dependencies for XMPP support,
# no actual code is provided here.
use Protocol::XMPP::Stream;
use Protocol::XMPP::Handler;

1;

__END__

=head1 NAME

Protocol::XMPP - Protocol-level support for XMPP interaction

=head1 VERSION

version 0.005

=head1 SYNOPSIS

 my $xmpp = Protocol::XMPP::Stream->new;
 $xmpp->();

=head1 DESCRIPTION

This module provides an API for the Extensible Message Passing Protocol.
This is commonly used for integration with Jabber servers and Google Talk,
although XMPP itself supports a number of extended features for a distributed
multi-server, multi-client message exchange system.

The primary implementation is based on RFC3920bis, which is still in flux. The
instant message support is defined by RFC3921bis.

The two main classes used here are L<Protocol::XMPP::Stream>, which provides
hooks for the underlying XML message stream, and L<Protocol::XMPP::Handler>,
which passes the SAX events from this stream on to appropriate handlers.

Client or server implementations should create an instance of the L<Protocol::XMPP::Stream>
class for each connection, passing callbacks to allow the protocol implementation to send
data over the connection and process received data.

=head1 IMPLEMENTATION

An overview of the connection lifetime for a typical client session:

=over 4

=item * Connect to server

=item * Establish session, including authentication and stream requirements such as TLS or
compression

=item * Retrieve roster

=item * Send presence update to server

=item * Send and receive messages as required

=item * Terminate session

=back

The details of connecting to sockets and upgrading to TLS are left to the implementation. This module deals with the
underlying protocol stream only, providing hooks that the implementation can call rather than attempting to implement
the functionality directly.

=head2 Roster

A roster is a list of contacts, each of which may also have presence information. This list is stored on the server,
although each client may also maintain a cached copy of the list.

Roster information is exchanged using L<Protocol::XMPP::IQ::Roster> queries and responses.

Roster includes the C<ver> information which is an opaque server token used to identify the version of the roster
information.

A roster query has a single item, and the response can have multiple.

Each item may also belong to zero or more groups.

Subscription states:

=over 4

=item * none - neither source nor destination contact have an existing subscription.

=item * to - we have a subscription to the contact, but they don't have us.

=item * from - they have us, we don't have them.

=item * both - mutual subscription.

=back

=head2 Presence notifications

=head1 MOTIVATION

This distribution is written with the intention to provide a base for XMPP implementations
which can work on an event-based ("asynchronous") or standard blocking model. It uses
L<XML::LibXML::SAX::ChunkedParser> to deal with the XML fragments required by the protocol,
and attempts to minimise any blocking operations.

=head1 SEE ALSO

=over 4

=item * L<AnyEvent::XMPP> - this is an event-based implementation of XMPP which appears to
be feature-complete enough to provide at least the standard instant message support. The
documentation is somewhat terse (choosing instead to focus on the implementation details of
XML in the protocol) but this module is worth a look if you want a more mature codebase.

=item * L<Net::XMPP> - another implementation, sadly the XML parser is blocking so although
it provides the L<Net::XMPP::Protocol> abstraction layer for the XMPP protocol, which probably
has better feature support than this module, it's not too suitable for dealing with asynchronous / 
event-based implementations. Also, I wasn't too keen on the direct checking for ref(), callback
setting and XML implementation here.

=item * L<Net::XMPP3::Protocol> - seems to be the same module as above, under a slightly different
namespace

=back

=head1 AUTHOR

Tom Molesworth <protocol-xmpp@entitymodel.com>

=head1 LICENSE

Copyright Tom Molesworth 2010-2011. Licensed under the same terms as Perl itself.