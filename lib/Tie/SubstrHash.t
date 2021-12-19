#!/usr/bin/perl -w

BEGIN {
    chdir 't' if -d 't';
    @INC = '.';
    push @INC, '../lib';
}

use strict;
use warnings;

use Test::More;

require Tie::SubstrHash;

my %a;

tie %a, 'Tie::SubstrHash', 3, 3, 3;

$a{abc} = 123;
$a{bcd} = 234;

cmp_ok( $a{abc}, '==', 123);

cmp_ok( keys %a, '==', 2 );

delete $a{abc};

cmp_ok( $a{bcd}, '==', 234 );

cmp_ok( (values %a)[0], '==', 234 );

eval { $a{abcd} = 123 };
like( $@, qr/Key "abcd" is not 3 characters long/ );

eval { $a{abc} = 1234 };
like( $@, qr/Value "1234" is not 3 characters long/ );

eval { $a = $a{abcd}; $a++ };
like( $@, qr/Key "abcd" is not 3 characters long/ );

@a{qw(abc cde)} = qw(123 345);

cmp_ok( $a{cde}, '==', 345);

eval { $a{def} = 456 };
like( $@, qr/Table is full \(3 elements\)/ );

%a = ();

cmp_ok( keys %a, '==', 0);

# Tests contributed by Linc Madison.

my $hashsize = 119;                # arbitrary values from my data
my %test;
tie %test, "Tie::SubstrHash", 13, 86, $hashsize;

for (my $i = 1; $i <= $hashsize; $i++) {
        my $key1 = $i + 100_000;           # fix to uniform 6-digit numbers
        my $key2 = "abcdefg$key1";
        $test{$key2} = ("abcdefgh" x 10) . "$key1";
}

for (my $i = 1; $i <= $hashsize; $i++) {
        my $key1 = $i + 100_000;
        my $key2 = "abcdefg$key1";
	ok ($test{$key2});
}

cmp_ok( Tie::SubstrHash::findgteprime(1), '==', 2 );

cmp_ok( Tie::SubstrHash::findgteprime(2), '==', 2 );

cmp_ok( Tie::SubstrHash::findgteprime(5.5), '==', 7);

cmp_ok( Tie::SubstrHash::findgteprime(13), '==', 13 );

cmp_ok( Tie::SubstrHash::findgteprime(13.000001), '==', 17 );

cmp_ok( Tie::SubstrHash::findgteprime(114), '==', 127 );

cmp_ok( Tie::SubstrHash::findgteprime(1000), '==', 1009);

cmp_ok( Tie::SubstrHash::findgteprime(1024), '==', 1031);

cmp_ok( Tie::SubstrHash::findgteprime(10000), '==', 10007);

done_testing();
