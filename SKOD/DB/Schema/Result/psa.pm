package SKOD::DB::Schema::Result::psa;
use strict;
use warnings;

use base 'DBIx::Class::Core';
__PACKAGE__->load_components(qw/UUIDColumns EncodedColumn Core/);

__PACKAGE__->table("psa");



__PACKAGE__->add_columns(
  "ID",
  { data_type => "text", is_nullable => 0 },
  "PSAID",
  { data_type     => "text", 
    unique        => 1, 
    is_nullable   => 0,

    encode_column => 1,
    encode_class  => 'Digest',
    encode_args   => { algorithm => 'SHA-1', format => 'hex' },
  },
  "TBL",
  { data_type => "text", is_nullable => 1 }, # make is_nullable => 0 in the future
);

__PACKAGE__->uuid_columns('ID');

__PACKAGE__->set_primary_key("ID");


=head1 RELATIONSHIPS

=head2 job (belongs_to)

Links a psa to its job.

=cut

__PACKAGE__->belongs_to(
    job =>
    'SKOD::DB::Schema::Result::jobs',
    { 'foreign.PSAID' => 'self.PSAID' }
  );


1;
