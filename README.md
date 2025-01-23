## Description
A simple perl server that does a postgres write and read used for a benchmark test running AnyEvent::HTTPD.

## Port 
8080

## Endpoint 
/api/benchmark 

## Docker commands
docker-compose up --build -d

## Benchmark CLI
ab -l -v 3 -c 10 -n 1000 "http://localhost:8080/api/benchmark" 
