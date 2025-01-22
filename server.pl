#!/usr/bin/perl -w 

use AnyEvent::HTTPD;
use Data::Dumper;
use JSON::XS;
use lib qw(./lib);
use strict;
use DBSimplePg;

$Data::Dumper::Sortkeys = 1;

my $db   = DBSimplePg->new();
my $port = 8080;
my $json = JSON::XS->new()->pretty;

init();

sub init {
	my $httpd = AnyEvent::HTTPD->new(port => $port);

	# Request routes.
	$httpd->reg_cb(
		'/api/benchmark' => sub {
			benchmark(@_);
		}
	);

	print "Listening on $port\n";
	$httpd->run;
}

sub insert_test_user {
	my $rand = int(rand(time));
	my $sql  = q~INSERT INTO users (name, email) VALUES (?, ?) RETURNING id~;
	my $row  = $db->write(sql => $sql, values => ["user_$rand", "user_$rand\@example.com"]);
	return $row->{id};
}

sub benchmark {
	my ($httpd, $req) = @_;

	my $id = insert_test_user();

	my $result = {};

	if ($id) {
		my $fetch = $db->read(sql => 'SELECT name, email FROM users where id = ?', values => [$id]);
		$result->{id}    = $id;
		$result->{fetch} = $fetch;
	}

	my $json_content = $json->encode($result);
	my @res          = keys %$result;
	my $status       = @res ? 200  : 400;
	my $msg          = @res ? 'OK' : 'Not Found';

	$req->respond([
		$status, $msg,
		{
			'Content-Type' => 'application/json',
		},
		$json_content
	]);
}
