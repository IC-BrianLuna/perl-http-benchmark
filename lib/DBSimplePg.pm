package DBSimplePg;

=head2

	A class for DBISimple wrapper for Postgres.

=cut

use strict;
use DBD::Pg;
use Data::Dumper;
use DBIx::Simple;

my %db_config = (
	user     => 'myuser',
	pass     => 'mypassword',
	host     => 'localhost',
	port     => 5432,
	database => 'mydatabase',
);

sub new {
	my ($self, %args) = @_;
	return bless \%args, $self;
}

sub connect {
	my ($self, %args) = @_;

	return $self->{dbh} if defined $self->{dbh} && $self->{dbh}{dbh}->ping;

	my $user     = $ENV{DATABASE_USER}     ? $ENV{DATABASE_USER}     : $db_config{user};
	my $pass     = $ENV{DATABASE_PASSWORD} ? $ENV{DATABASE_PASSWORD} : $db_config{pass};
	my $host     = $ENV{DATABASE_HOST}     ? $ENV{DATABASE_HOST}     : $db_config{host};
	my $port     = $ENV{DATABASE_PORT}     ? $ENV{DATABASE_PORT}     : $db_config{port};
	my $database = $ENV{DATABASE_NAME}     ? $ENV{DATABASE_NAME}     : $db_config{database};

	if ($database) {
		my $dsn    = "dbi:Pg:dbname=$database;host=$host;port=$port";
		my $config = { RaiseError => 1, AutoCommit => 1 };

		$self->{dbh} = DBIx::Simple->connect($dsn, $user, $pass, $config);

		if (!$self->{dbh}) {
			warn "Database connection error: " . DBI->errstr;
		}

	} else {
		warn "Error - you did not pass in the database param! $!\n";
	}

	return $self->{dbh};
}

sub read {
	my ($self, %args) = @_;

	my $sql    = $args{sql};
	my $map    = $args{map};
	my $values = $args{values} ? $args{values} : [];
	my @values = @$values      ? @$values      : ();

	my $result;

	if ($sql) {
		my $dbh = $self->connect();

		if ($map) {
			$result = $dbh->query($sql, @values)->map_hashes($map);
		} else {
			$result = $dbh->query($sql, @values)->hashes;
		}
	}

	return $result;
}

sub write {
	my ($self, %args) = @_;

	my $sql    = $args{sql};
	my $values = $args{values} ? $args{values} : [];
	my @values = @$values      ? @$values      : ();

	my $rec;

	if ($sql) {
		my $dbh = $self->connect();
		$rec = $dbh->query($sql, @values)->hash;
	}

	return $rec;
}

1;
