#!/usr/bin/perl -w 

use strict;
use lib qw(./lib);

use bytes;
use JSON::XS;
use DBSimplePg;
use Data::Dumper;
use AnyEvent::HTTPD;
use Prometheus::Tiny;

$Data::Dumper::Sortkeys = 1;

my $db         = DBSimplePg->new();
my $port       = 8080;
my $json       = JSON::XS->new();
my $prometheus = Prometheus::Tiny->new();

init();

sub init {
    my $httpd = AnyEvent::HTTPD->new( port => $port );

    $prometheus->declare(
        'benchmark_requests_total',
        help => 'Total benchmark requests',
        type => 'counter'
    );

    $prometheus->declare(
        'benchmark_last_insert_time',
        help => 'Last user insert time',
        type => 'gauge'
    );

    # Request routes.
    $httpd->reg_cb(
        '/benchmark' => sub {
            benchmark(@_);
        },
        '/metrics' => sub {
            my ( $httpd, $req ) = @_;
            $req->respond(
                [
                    200,                                'OK',
                    { 'Content-Type' => 'text/plain' }, $prometheus->format
                ]
            );
        }
    );

    print "Listening on $port\n";
    $httpd->run;
}

sub insert_test_user {
    my $rand = int( rand(time) );
    my $sql  = q~INSERT INTO users (name, email) VALUES (?, ?) RETURNING id~;
    my $row  = $db->write(
        sql    => $sql,
        values => [ "user_$rand", "user_$rand\@example.com" ]
    );

    $prometheus->set( 'benchmark_last_insert_time', time );

    return $row->{id};
}

sub benchmark {
    my ( $httpd, $req ) = @_;

    $prometheus->inc('benchmark_requests_total');
    my $id = insert_test_user();

    my $result = {};

    if ($id) {
        my $fetch = $db->read(
            sql    => 'SELECT name, email FROM users WHERE id = ?',
            values => [$id]
        );
        $result->{id}    = $id;
        $result->{fetch} = $fetch;
    }

    my $json_content   = $json->encode($result);
    my $content_length = bytes::length($json_content);

    my @res    = keys %$result;
    my $status = @res ? 200  : 400;
    my $msg    = @res ? 'OK' : 'Not Found';

    $req->respond(
        [
            $status, $msg,
            {
                'Content-Type'   => 'application/json',
                'Content-Length' => $content_length,
                'Connection'     => 'close',
            },
            $json_content
        ]
    );
}
