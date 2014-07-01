package LS::Server;

use utf8;
use Moo;
use warnings NONFATAL => 'all';
use experimental 'signatures';

use Log::Contextual qw(:log :dlog);

use LS::Session;

extends 'IO::Async::Listener';

has ip => (
   is => 'ro',
   default => '127.0.0.1',
);

has port => (
   is => 'ro',
   default => 9933,
);

sub on_accept ($self, $sock) {
   log_info { "client connected: " . $sock->peerhost . ':' . $sock->peerport };

   my $session = LS::Session->new( handle => $sock );
   $self->add_child( $session );
}

sub listen ($s) {
   $s->next::method(
      addr => {
         family => 'inet',
         socktype => 'stream',
         port => $s->port,
         ip => $s->ip,
      },

      on_resolve_error => sub { die "Cannot resolve - $_[1]\n"; },
      on_listen_error  => sub { die "Cannot listen - $_[1]\n"; },
   );
}

1;
