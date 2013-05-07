package SKOD::ETL;
use Moose;
use SKOD::DB::Schema;
use DBIx::Class::ResultClass::HashRefInflator; 
use Try::Tiny;
use AnyEvent;
use Data::Dumper;

has 'db'     => (
  is => 'rw'
);

has 'dbdsn'  => (
  is => 'rw',
);

has 'dbname' => (
  is => 'rw'
);

has 'dbuser' => (
  is => 'rw'
);

has 'dbpass' => (
  is => 'rw'
);

has 'loopinterval' => (
  is => 'rw'
  ,default => 1 # 1 minute
);

has 'debug' => (
  is => 'rw',
  default => 0,
);

sub connect{
  my $self = shift;

  $self->db( @_ ? SKOD::DB::Schema->connect(@_) # just pass directly to DBIx::Class connect
                : SKOD::DB::Schema->connect($self->dbdsn, $self->dbuser, $self->dbpass ) # or use moose stuff
  );

  $self->db->storage->debug($self->debug);
};

sub dump{
  my $self = shift;
  my $tbl  = shift;

  my $rows = $self->db->resultset($tbl)->search({}, {
        result_class => 'DBIx::Class::ResultClass::HashRefInflator',
  });
  while(my $hashref = $rows->next){
    print Dumper $hashref;
  }

};

sub start{
  my $self = shift;
  print 'looping at interval: ' . $self->{loopinterval} . "\n";
  $self->{eventtimer} = AE::timer 0, $self->{loopinterval}, sub{
    #EVENT LOOP
    print 'called';
  };
  $self->{eventloop} = AE::cv;
  $self->{eventloop}->recv;
  return 1;
};


1;
