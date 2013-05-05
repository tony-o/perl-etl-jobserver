package SKOD::ETL;
use Moose;
use DBIx::Simple;
use Digest::MD5 qw(md5_hex);
use Try::Tiny;
use UUID::Tiny;
use AnyEvent;
use Data::Dumper;

has 'db'     => (
  is => 'rw'
);

has 'dbdsn'  => (
  is => 'rw'
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

sub connect{
  my $self = shift;
  $self->db(DBIx::Simple->connect($self->dbdsn, $self->dbuser, $self->dbpass));
  if($self->dbname){
    $self->db->query('USE ' . $self->dbname . ';');
  }
};

sub register{ #REGISTERS A NEW JOB
  my $self   = shift;
  my $name   = shift;
  my $psa    = md5_hex($name);
  my $return = 1;
  try{
    $self->db->query('INSERT INTO jobs (PSA, NAM) VALUES (??);', ($psa, $name));
  }catch{
    $return = $_;
  }
  return $return;
};

sub genuuid{
  my $self = shift;
  return create_UUID_as_string(UUID_V4);
};

sub dump{
  my $self = shift;
  my $tbl  = shift;
  my $rows = $self->db->query('SELECT * FROM ' . $tbl . ';')->hashes;
  print Dumper($rows);
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
