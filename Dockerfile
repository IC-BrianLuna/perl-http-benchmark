FROM ubuntu:latest

RUN apt-get update
RUN apt-get install -y libdbd-pg-perl libjson-perl libjson-xs-perl libanyevent-httpd-perl libdbix-simple-perl libprometheus-tiny-perl
RUN apt-get clean

ENV PERL5LIB /usr/share/perl5

WORKDIR /app
COPY server.pl /app/
RUN chmod +x /app/server.pl
COPY lib/ /app/lib/ 
EXPOSE 8080
CMD ["./server.pl"]

# sudo docker run -p 9090:9090 -v $(pwd)/prometheus.yml:/etc/prometheus/prometheus.yml prom/prometheus
