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

$etl->connect();
my $job = $etl->register("PETERPAN");
print Dumper($job);
$etl->dump("jobs");
$etl->loopinterval(.1);
$etl->start();
