use strict;
use warnings;
use Test::More;

use Config;

BEGIN {
    if ($Config{extensions} !~ /\bSys\/Hostname\b/) {
      plan skip_all => "Skip: Sys::Hostname was not built";
    }
}
BEGIN { use_ok('Sys::Hostname'); }

SKIP:
{
    my $host;
    eval {
        $host = hostname;
    };
    skip "No hostname available", 1
      if $@ =~ /Cannot get host name/;
    isnt($host, undef, "got a hostname");
}

{
    local $@;
    eval { hostname("dummy"); };
    like($@, qr/^Too many arguments/);
}

done_testing;
