package Finance::ID::KSEI;

# AUTHORITY
# DATE
# DIST
# VERSION

use 5.010001;
use strict;
use warnings;
use Log::ger;

use Exporter qw(import);
our @EXPORT_OK = qw(
                       get_ksei_sec_ownership
               );

our %SPEC;

$SPEC{':package'} = {
    v => 1.1,
    summary => 'Get information from KSEI (Kustodian Sentral Efek Indonesia) (Indonesian Central Securities Depository)',
};

$SPEC{get_ksei_sec_ownership_url} = {
    v => 1.1,
    summary => 'Get KSEI securities ownership information',
    description => <<'_',

KSEI provides this in the form of monthly ZIP file. This function will just try
to search the URL and return it.

_
    args => {
        year => {
            schema => 'date::year*',
            req => 1,
            pos => 0,
        },
        month => {
            schema => 'date::month_num*',
            req => 1,
            pos => 1,
        },
    },
};
sub get_ksei_sec_ownership_url {
    require DateTime;
    require HTTP::Tiny;

    my %args = @_;

    # get the last weekday of the month
    my $dt = DateTime->new(year => $args{year}, month => $args{month}, day => 1);
    $dt->add(months => 1)->subtract(days => 1);
    while ($dt->day_of_week > 5) { $dt->subtract(days => 1) }

    # it may be a holiday, we don't consult Calendar::Indonesian::Holiday
    # because IDX holiday might be slightly different. so we just try to probe
    # for the URL for two weeks before giving up.
    for (1..14) {
        my $url = sprintf(
            "https://www.ksei.co.id/Download/BalanceposEfek%04d%02d%02d.zip",
            $dt->year, $dt->month, $dt->day,
        );
        log_trace "Trying $url ...";
        my $res = HTTP::Tiny->new->head($url);
        if ($res->{status} == 404) {
            while (1) { $dt->subtract(days => 1); last unless $dt->day_of_week > 5 }
            next;
        } elsif ($res->{status} == 200) {
            return [200, "OK", $url];
        } else {
            return [500, "Failed when trying URL '$url': $res->{status} - $res->{reason}"];
        }
    }
    return [500, "Giving up after not finding the URL for 14 dates"];
}

1;
# ABSTRACT:

=head1 DESCRIPTION


=head1 SEE ALSO

L<Finance::SE::IDX>
