# Description
A simple perl server that does a postgres write and read used for a benchmark test running AnyEvent::HTTPD.
Which also runs prometheus.

# Docker commands
docker-compose up --build -d

# Prometheus endpoint
http://localhost:9090

# Metrics endpoint
http://localhost:8080/metrics

# Metrics endpoint
http://localhost:8080/benchmark

# Benchmark CLI
ab -l -v 3 -c 10 -n 10000 "http://localhost:8080/benchmark" 
