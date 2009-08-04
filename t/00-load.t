#!perl -T

use Test::More tests => 1;

BEGIN {
	use_ok( 'YellowBot::API' );
}

diag( "Testing YellowBot::API $YellowBot::API::VERSION, Perl $], $^X" );
