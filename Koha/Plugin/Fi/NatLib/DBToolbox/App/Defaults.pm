package Koha::Plugin::Fi::NatLib::DBToolbox::App::Defaults;
use Modern::Perl; use utf8; use open qw(:utf8);

our $CONFIGURATION = [

    {   name => 'nightly_cron_enabled',
        type => 'checkbox',
        default => undef,
        name_display => 'Enable nightly execution of enabled cleanup tasks',
        description => 'this means plugin will run at night executing some assigned DB-fix and clean tasks',
    },

];

1;
