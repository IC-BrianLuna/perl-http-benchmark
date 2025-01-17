## Description
A simple perl server that returns a string used for a benchmark test running AnyEvent::HTTPD.

## Port 
8080

## Endpoint 
/api/devices 

## Dependancies 
libjson-perl

libjson-xs-perl

libanyevent-httpd-perl

# Docker commands
docker build -t my-perl-server .

docker run -d -p 8080:8080 --name perl-server my-perl-server
