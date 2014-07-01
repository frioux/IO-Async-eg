package LS::Session;

use utf8;
use Moo;
use warnings NONFATAL => 'all';

use curry::weak;
extends 'IO::Async::Stream';

use Log::Contextual qw(:log :dlog);
use IO::Async::Timer::Countdown;

use LS::Protocol;

has protocol => (
   is => 'ro',
   lazy => 1,
   default => sub {
      my $self = shift;
      my $write = $self->curry::weak::write;
      my $timer = $self->timer;
      LS::Protocol->new(
         write => sub {
            $write->(@_);
            $timer->reset;
         },
         raw_write => $write,
      ),
   },
);

has timer => (
   is => 'ro',
   lazy => 1,
   default => sub {
      my $self = shift;

      # this is curried like this so that we don't recursively create the timer
      # and the protocol
      my $protocol = $self->curry::weak::protocol;

      IO::Async::Timer::Countdown->new(
         delay => 60,
         on_expire => sub {
            my $timer = shift;

            $protocol->()->lub;

            $timer->start
         },
      )
   },
);

sub BUILD {
   my $self = shift;
   my $timer = $self->timer;
   $self->add_child($timer);
   $timer->start;
   return $self;
}

sub on_read {
   my ( $self, $buffref, $eof ) = @_;
   $self->protocol->respond($$buffref);
   $$buffref = "";
   return 0;
}

sub on_closed { log_info { "client disconnected" } }

1;
