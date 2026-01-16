package Koha::Plugin::Fi::NatLib::DBToolbox::App::RuntimeReport;
use Modern::Perl; use utf8; use open qw(:utf8);


## ----------------------------------------
## Plugin runtime REPORT phase
## ----------------------------------------

sub runtime_report_mode {
    my ( $self, $args ) = @_;
    my $cgi = $self->{plugin}{cgi};

    $self->go_home();

    return;
}


1;
