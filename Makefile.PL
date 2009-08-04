use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'YellowBot::API',
    AUTHOR              => 'Ask Bjørn Hansen <ask@develooper.com>',
    VERSION_FROM        => 'lib/YellowBot/API.pm',
    ABSTRACT_FROM       => 'lib/YellowBot/API.pm',
    ($ExtUtils::MakeMaker::VERSION >= 6.3002
      ? ('LICENSE'=> 'perl')
      : ()),
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More' => 0,
        'Moose'      => 0,
        'URI'        => 0,
        'LWP::UserAgent' => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'YellowBot-API-*' },
);
