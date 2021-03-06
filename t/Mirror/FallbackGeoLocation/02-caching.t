#!/usr/bin/perl -w

use strict;
use warnings;
use Test::More;

use Storable qw(retrieve);
use Mirror::FallbackGeoLocation;

my $db;
eval {
    $db = retrieve('db');
    plan tests => 3;
};
if ($@) {
    plan skip_all => "Failed to retrieve db: $@";
    exit;
}

my $rec1;

ok($rec1 = Mirror::FallbackGeoLocation::get_record($db, 'archive'), 'Can get a record');

# The lookup should now be in the cache
$db = undef;

my $rec2 = Mirror::FallbackGeoLocation::get_record($db, 'archive');
can_ok($rec2, qw(city continent_code country_code latitude longitude region));

is_deeply($rec1, $rec2, 'The two records should be equal');
