FROM ubuntu:latest

RUN apt-get update
RUN apt-get install -y libjson-perl
RUN apt-get install -y libjson-xs-perl
RUN apt-get install -y libanyevent-httpd-perl
RUN apt-get clean

ENV PERL5LIB /usr/share/perl5

# Copy the app.
COPY server.pl .
EXPOSE 8080
CMD ["./server.pl"]
