package Koha::Plugin::Fi::NatLib::DBToolbox;
use Modern::Perl; use utf8; use open qw(:utf8);
use base qw(Koha::Plugins::Base);

use Koha::Plugin::Fi::NatLib::DBToolbox::App;

use Koha::DateUtils ();


## ----------------------------------------
## Plugin description metadata
## ----------------------------------------

our $VERSION = "{VERSION}";
our $metadata = {
    name            => 'DB Toolbox: Check, Fix, Clean, Repeat',
    author          => 'Kansalliskirjasto Koha Dev Team / Andrii, Slava, Petro',
    description     => 'All-in-one Koha DB maintenance toolbox: checks and reports common issues, runs targeted fixes, and cleans obsolete data. Designed for manual runs or scheduled nightly maintenance.',
    homepage        => 'https://github.com/NatLibFi/koha-plugin-db-toolbox',
    date_authored   => '2026-01-15',
    date_updated    => '1970-01-01',
    minimum_version => '23.1100000',
    maximum_version => undef,
    version         => $VERSION,
    default_method  => __PACKAGE__->can('tool') ? 'tool' : __PACKAGE__->can('report') ? 'report' : __PACKAGE__->can('configure') ? 'configure' : '',
};


## ----------------------------------------
## Configuration screen values
## (each plugin should have a few)
## ----------------------------------------

our $configuration = [
    @$Koha::Plugin::Fi::NatLib::DBToolbox::App::Defaults::CONFIGURATION,
    {   name => 'log_level',
        type => 'select',
        default => 1,
        name_display => 'Log level',
        description => 'Log level for plugin',
        options => [
            { value => 4, label => 'Debug'  },
            { value => 3, label => 'Notice' },
            { value => 2, label => 'Info'   },
            { value => 1, label => 'Warn'   },
            { value => 0, label => 'Error'  },
        ],
    },
    {   name => 'log_preserve',
        type => 'select',
        default => 3,
        name_display => 'Preserve log for',
        description => 'how long to store log data',
        options => [
            { value => 4, label => '1 day' },
            { value => 3, label => '2 days' },
            { value => 2, label => '1 week' },
            { value => 1, label => '1 month' },
            { value => 0, label => '3 months' },
        ],
    },
];


## ----------------------------------------
## Which methods we have acrive in our plugin
## ----------------------------------------
## just have it here declaured, but they then subcalled to App-> methods to have modularization.

## no critic (Subroutines::RequireArgUnpacking);

sub install   { my $self = shift; $self->{app}->preconfig($self); return $self->{app}->init_install_plugin(@_); }
sub uninstall { my $self = shift; $self->{app}->preconfig($self); return $self->{app}->init_uninstall_plugin(@_); }
sub upgrade   { my $self = shift; $self->{app}->preconfig($self);
    warn "--- PLUGIN: " . __PACKAGE__ . " upgrading now. ---\n";
    Koha::Caches->get_instance('plugins')->clear_from_cache($self->{app}{config_cache_key});
    my $dt = Koha::DateUtils::dt_from_string();
    $self->store_data( { last_upgraded => $dt->ymd('-') . ' ' . $dt->hms(':') } );
    $self->{app}->preconfig($self);
    return $self->{app}->init_upgrade_plugin(@_);
}

# consider this should be enabled even no cron jobs you have, but if you want log to be cleaned nightly:
sub cronjob_nightly { return shift->{app}->cronjob_nightly(@_); }

sub configure   { return shift->{app}->configure_plugin(@_); }
# sub report      { return shift->{app}->runtime_report_mode(@_); }
# sub tool        { return shift->{app}->runtime_tool_mode(@_); }
# sub intranet_js { return shift->{app}->runtime_intranet_js(@_); }

# sub intranet_catalog_biblio_enhancements_toolbar_button { return shift->{app}->intra_biblio_tbbutton(@_); }


# Almost predefined, required for breadcrumbs to work,
# but unless you need extra include folders, add some here:
sub template_include_paths { my $self = shift; return [ $self->mbf_path('templates/includes') ]; }

## -----------------------------------------------
## Predefined new method below, no need to change
## -----------------------------------------------

sub new {
    my ( $class, $args ) = @_;
    my $self = $class->SUPER::new({ %{$args//{}},
        metadata => { %$metadata, class => $class },
        app => Koha::Plugin::Fi::NatLib::DBToolbox::App->new({ configuration => $configuration }),
    });
    $self->{app}->preconfig($self);
    return $self;
}

1;
