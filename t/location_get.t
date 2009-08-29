#!perl -T

use Test::More;

my $api_key    = $ENV{API_KEY};

plan skip_all => "API_KEY environment variables must be set" unless $api_key;

plan tests => 4;

use_ok( 'YellowBot::API' );

ok(my $api = YellowBot::API->new
   (api_key    => $api_key,
   ), 'new');

$api->server($ENV{API_SERVER} || 'http://www.yellowbot.com/');

ok(my $data = $api->call('location/details', api_version=>1, id => '/solfo-burbank-ca.html'), 'fetch solfo data');
is($data->{locations}->[0]->{name}, 'Solfo', 'got correct name');

