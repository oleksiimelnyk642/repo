#Dockerfile that install 2 virtual web hosts example.com and qsxdrgb.com on Apache server

FROM ubuntu:latest
Maintainer oleksiimelnyk

RUN apt-get update -y 
RUN apt-get install -y apache2 vim
EXPOSE 80 81

#Copy config file
COPY ./apache2.conf /etc/apache2/conf/apache2.conf
COPY ./example.com /var/www/example.com
COPY ./example2.com /var/www/example2.com
COPY ./sites-available /etc/apache2/sites-available
COPY ./sites-enabled /etc/apache2/sites-enabled



