package SKOD::DB::Schema::ResultSet::jobs;

use strict;
use warnings;
use base 'DBIx::Class::ResultSet';

=head1 METHODS

=head2 register

Creates a new job. Basically just an exmaple/wrapper around dbix::class's ->create()

=cut

sub register{ #REGISTERS A NEW JOB
  my ($self, $name) = @_;
  my $psa = $name; #md5_hex($name); hashing is done in DB::Schema::Result::jobs.pm automatically 

  my $new_job = $self->create({ PSAID => $psa, NAM => $name, }); 
  $new_job->create_related('psas', { });  # our relationship to psa table, PSAID is set magically via its relationship 

  return $new_job; # we return the dbix::class object, #yospos
}


1;