requires 'Moo';
requires 'curry';
requires 'Log::Contextual';
requires 'Log::Log4perl';
requires 'IO::Async';
requires 'JSON::MaybeXS';
requires 'namespace::clean';
requires 'perl' => 5.020;

on test => sub {
   requires 'Test::More';
   requires 'Test::Deep';
};
