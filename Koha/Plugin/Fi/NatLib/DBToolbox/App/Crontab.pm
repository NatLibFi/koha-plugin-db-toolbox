package Koha::Plugin::Fi::NatLib::DBToolbox::App::Crontab;
use Modern::Perl; use utf8; use open qw(:utf8);

use File::Temp ();
use Mojo::UserAgent ();
use IPC::Cmd ();
use Cwd ();


## ----------------------------------------
## Plugin CRONTAB element
## ----------------------------------------

sub cronjob_nightly {
    my ( $self ) = @_;

    return
        unless $self->{config}{nightly_cron_enabled};

    $self->logf( 'INFO', "Nightly cronjob SYNC STARTED." );

    ###

    print "Remember to put some sane code here :)\n";

    ###

    $self->logf( 'INFO', "Nightly cronjob SYNC ENDED." );

    return;
}

1;
