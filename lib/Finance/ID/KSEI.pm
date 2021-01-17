package Finance::ID::KSEI;

# AUTHORITY
# DATE
# DIST
# VERSION

use 5.010001;
use strict;
use warnings;

use Exporter qw(import);
our @EXPORT_OK = qw(
                       get_ksei_sec_ownership
                       get_ksei_sec_data
               );

our %SPEC;

$SPEC{':package'} = {
    v => 1.1,
    summary => 'Get information from KSEI (Kustodian Sentral Efek Indonesia) (Indonesian Central Securities Depository)',
};

1;
# ABSTRACT:

=head1 DESCRIPTION

Not yet implemented, name grab only.


=head1 SEE ALSO

L<Finance::SE::IDX>
