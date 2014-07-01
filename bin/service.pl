#!/usr/bin/env perl

use 5.20.0;
use warnings;

use rlib;

use Log::Log4perl qw(:easy);
Log::Log4perl->easy_init($TRACE);
use Log::Contextual
   -logger => sub { Log::Log4perl->get_logger($_[0]) },
   qw(:log :dlog);

use IO::Async::Loop;
use LS::Server;

my $loop = IO::Async::Loop->new;
my $listener = LS::Server->new;

$loop->add( $listener );

$listener->listen;

log_info { "Listening on: " . $listener->port };

$loop->run;

