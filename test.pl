use strict;
use warnings;

use SKOD::ETL;

use Data::Dumper;

my $etl = SKOD::ETL->new;
$etl->debug(1);

# Need to rework this to $etl->db->connect
$etl->connect('dbi:SQLite:db.db', 'user', 'pass');

# should find a way so ->resultset('jobs') gets its own jobs object, so:
# $etl->db->jobs->register("PETERPAN")
my $job = $etl->db->resultset('jobs')->register("PETERPAN");
$etl->dump("jobs");

no warnings; # turn off warnings until $job->psa->TBL cannot be null
print "\n\n" . 
      "[job] ID:\t"     . $job->ID         . "\n" .
      "[job] PSAID:\t"  . $job->PSAID      . "\n" .
      "[job] NAM:\t"    . $job->NAM        . "\n" .
      "\n";
print "\t[psa] ID:\t"     . $_->ID    . "\n" .
      "\t[psa] PSAID:\t"  . $_->PSAID . "\n" . 
      "\t[psa] TBL:\t"    . $_->TBL   . "\n\n" foreach($job->psas);
print "\n";
use warnings;


$etl->loopinterval(.1);
$etl->start();
