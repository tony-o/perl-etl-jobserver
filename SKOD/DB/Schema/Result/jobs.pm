package SKOD::DB::Schema::Result::jobs;
use strict;
use warnings;

use base 'DBIx::Class::Core';
__PACKAGE__->load_components;

__PACKAGE__->table("jobs");

__PACKAGE__->add_columns(
  "ID",
  { data_type => "int", is_nullable => 0 },
  "PSA",
  { data_type => "text", unique => 1, is_nullable => 0 },
  "NAM",
  { data_type => "text", is_nullable => 0 },
);

__PACKAGE__->set_primary_key("ID");


1;
