FROM ubuntu:latest

RUN apt-get update
RUN apt-get install -y libdbd-pg-perl
RUN apt-get install -y libjson-perl
RUN apt-get install -y libjson-xs-perl
RUN apt-get install -y libanyevent-httpd-perl
RUN apt-get install -y libdbix-simple-perl
RUN apt-get clean

ENV PERL5LIB /usr/share/perl5

COPY server.pl .
COPY lib/ lib/ 
EXPOSE 8080
CMD ["./server.pl"]
