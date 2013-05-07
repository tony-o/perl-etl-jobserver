package SKOD::DB::Schema;
use strict;
use warnings;

use base 'DBIx::Class::Schema';

__PACKAGE__->load_namespaces;

=head1 OVERLOADED METHODS

=head2 connection (connect)

Example of how to naively deploy tables from schemas automatically or do other init stuff. 

=cut

sub connection {
  # underlying function of convience method ->connect(), noted in the dbix::class docs
  my ( $self, @args ) = @_;
  $self->next::method(@args);
  $self->deploy; # example: generates tables if they don't exist, otherwises ugly warnings
                # should be handled properly when less fucked up

  return $self;
}

1;
