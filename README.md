## Description
A simple perl server that returns a string used for a benchmark test running AnyEvent::HTTPD.

## Port 
8080

## Endpoint 
/api/benchmark 

## Dependancies 
libjson-perl

libjson-xs-perl

libanyevent-httpd-perl

## Docker commands
docker-compose up --build -d

## Benchmark CLI
ab -v 3 -c 10 -n 1000 "http://localhost:8080/api/benchmark" 
