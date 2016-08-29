FROM ubuntu:trusty
RUN apt-get update && apt-get install -y --force-yes sudo apache2
EXPOSE 80 443
#VOLUME ["/var/www", "/var/log/apache2", "/etc/apache2"]
USER 1005790000
#USER 1001
#
ENTRYPOINT /usr/sbin/apache2ctl -D FOREGROUND
#CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
