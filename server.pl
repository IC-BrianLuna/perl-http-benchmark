#!/usr/bin/perl -w 

use AnyEvent::HTTPD;
use Data::Dumper;
use JSON::XS;
use strict;

$Data::Dumper::Sortkeys = 1;

my $port = 8080;
my $json = JSON::XS->new();

init();

sub init {
	my $httpd = AnyEvent::HTTPD->new(port => $port);

	# Request routes.
	$httpd->reg_cb(
		'/api/devices' => sub {
			devices(@_);
		}
	);

	print "Listening on $port\n";
	$httpd->run;
}

sub devices {
	my ($httpd, $req) = @_;

	my $devices = {
		id       => 1,
		mac      => 'EF-2B-C4-F5-D6-34',
		firmware => '2.1.5',
	};

	my $json_content = $json->encode($devices);

	$req->respond([
		200, 'OK',
		{
			'Content-Type' => 'application/json',
		},
		$json_content
	]);
}
