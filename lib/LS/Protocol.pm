package LS::Protocol;

use utf8;
use Moo;
use warnings NONFATAL => 'all';

use JSON::MaybeXS;
use namespace::clean;
use experimental 'signatures';

has _write => (
   is => 'ro',
   required => 1,
   init_arg => 'write',
);
sub write ($s, $c) { $s->_write->(encode_json($c) . "\n") }

has _raw_write => (
   is => 'ro',
   required => 1,
   init_arg => 'raw_write',
);
sub raw_write ($s, $c) { $s->_raw_write->(encode_json($c) . "\n") }

has _count => ( is => 'rw', default => 0 );
sub count ($s) { $s->_count($s->_count + 1) }

sub respond ($s, $str) { $s->write({ count => $s->count, str => $str }) }

sub lub ($s) {
   $s->raw_write($s->command('Heartlub', { Lub => int rand(100) }))
}

sub command ($, $cmd, @args) {
   return {
      Command => $cmd,
      Args    => [@args],
   }
}

1;
