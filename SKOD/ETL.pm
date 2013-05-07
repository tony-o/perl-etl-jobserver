package SKOD::ETL;
use Moose;
use SKOD::DB::Schema;
use DBIx::Class::ResultClass::HashRefInflator; 
use Digest::MD5 qw(md5_hex);
use Try::Tiny;
use UUID::Tiny;
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
  $self->db( SKOD::DB::Schema->connect($self->dbdsn, $self->dbuser, $self->dbpass ) );
  $self->db->storage->debug($self->debug);
  #$self->db->deploy; # example: generates tables if they don't exist, otherwises ugly warnings
                      # should be handled properly when less fucked up
};

sub register{ #REGISTERS A NEW JOB
  my $self   = shift;
  my $name   = shift;
  my $psa    = $name; #md5_hex($name); hashing is done in DB::Schema::Result::jobs.pm automatically 
  my $return = 1;

  return 1 if $self->db->resultset('jobs')->create({ PSA => $psa, NAM => $name });
};

sub genuuid{
  my $self = shift;
  return create_UUID_as_string(UUID_V4);
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
