use strict;
use warnings;

use SKOD::ETL;

use Data::Dumper;

my $etl = SKOD::ETL->new;
$etl->dbdsn("dbi:SQLite:db.db");
#$etl->dbname("skodetl");
$etl->dbuser("user");
$etl->dbuser("pass");
$etl->debug(1);

# DBIx::Class style and Moose style (both work)
 $etl->connect($etl->dbdsn, $etl->dbuser, $etl->dbpass);
#$etl->connect();

# should find a way so ->resultset('jobs') gets its own jobs object, so:
# $etl->db->jobs->register("PETERPAN")
my $job = $etl->db->resultset('jobs')->register("PETERPAN");
$etl->dump("jobs");

no warnings; # turn off warnings until $job->psa->TBL cannot be null
print "\n\n" . 
      "[job] ID:\t"   . $job->ID         . "\n" .
      "[job] PSAID:\t" . $job->PSAID      . "\n" .
      "[job] NAM:\t"   . $job->NAM        . "\n" .
      "\n" .
      "[psa] ID:\t"     . $job->psa->ID    . "\n" .
      "[psa] PSAID:\t"  . $job->psa->PSAID . "\n" . 
      "[psa] TBL:\t"    . $job->psa->TBL   . "\n" .
      "\n";
use warnings;


$etl->loopinterval(.1);
$etl->start();
