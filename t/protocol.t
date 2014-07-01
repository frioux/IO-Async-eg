#!/usr/bin/env perl

use 5.20.0;
use warnings;

use Test::More;
use Test::Deep;
use JSON::MaybeXS;

use LS::Protocol;

ok my $p = LS::Protocol->new(
   write     => sub { return $_[0] },
   raw_write => sub { return $_[0] },
), 'instantiation';

cmp_deeply(decode_json($p->lub), {
   Command => 'Heartlub',
   Args => [{ Lub => ignore() }],
}, 'lub');

cmp_deeply(decode_json($p->respond("derp")), {
   count => 1,
   str => "derp",
}, 'respond');

cmp_deeply(decode_json($p->respond("herp")), {
   count => 2,
   str => "herp",
}, 'respond 2');

done_testing;
