#FROM ubuntu:xenial
FROM ubuntu:trusty
#FROM x3193/dc:latest
#FROM x3193/ubt1404:latest
MAINTAINER x3193.tk <x3193@x3193.tk> 

ENV DEBIAN_FRONTEND noninteractive
ENV HOME /root
ENV USER root
ENV AUTHORIZED_KEYS **None**
ENV ROOT_PASS EUIfgwe7

#1001
RUN adduser --shell /bin/bash --system --ingroup root --force-badname --uid 1001 ops
RUN echo "ops ALL=(ALL:ALL) NOPASSWD: ALL" >> /etc/sudoers
RUN echo "Defaults visiblepw" >> /etc/sudoers
RUN usermod -a -G ops
RUN usermod -a -G adm ops
USER ops

# Install packages
RUN sudo dpkg --configure -a && sudo apt-get install -f && sudo apt-get update && sudo DEBIAN_FRONTEND=noninteractive apt-get -y install expect sudo net-tools openssh-server pwgen zip unzip python-numpy python3-numpy cron
#RUN dpkg --configure -a && apt-get install -f && apt-get update && DEBIAN_FRONTEND=noninteractive apt-get -y install sudo net-tools openssh-server pwgen zip unzip python-numpy python3-numpy cron
RUN sudo mkdir -p /var/run/sshd && sudo sed -i "s/UsePrivilegeSeparation.*/UsePrivilegeSeparation no/g" /etc/ssh/sshd_config && sudo sed -i "s/UsePAM.*/UsePAM no/g" /etc/ssh/sshd_config && sudo sed -i "s/PermitRootLogin.*/PermitRootLogin yes/g" /etc/ssh/sshd_config

ADD sudo set_root_pw.sh /set_root_pw.sh
ADD sudo run.sh /run.sh
RUN sudo chmod +x /*.sh

#root pw
RUN sudo sh /set_root_pw.sh

ADD sudo run-apache2.sh /run-apache2.sh
RUN sudo chmod a+x /run-apache2.sh

RUN sudo echo "====="
#1001
RUN sudo adduser --shell /bin/bash --system --ingroup root --force-badname --uid 1001 ops
RUN sudo echo "ops ALL=(ALL:ALL) NOPASSWD: ALL" >> /etc/sudoers
RUN sudo echo "Defaults visiblepw" >> /etc/sudoers
RUN sudo usermod -a -G sudo ops
RUN sudo usermod -a -G adm ops
#ssh
#RUN echo "1000340000 ALL=(ALL:ALL) NOPASSWD: ALL" >> /etc/sudoers
RUN sudo chown -R 1000340000:root /etc/ssh/
RUN sudo chmod -R 0700 /etc/ssh/
RUN sudo echo "AllowUsers ops 1000340000" >> /etc/ssh/sshd_conf
RUN sudo sed -i "s/Port 22*/Port 2222/g" /etc/ssh/sshd_config
RUN sudo service ssh restart
RUN sudo cat /etc/ssh/sshd_config
RUN sudo cat /etc/ssh/sshd_conf
RUN sudo echo "====="
#apache2
#ENV APACHE_RUN_USER ops
#ENV APACHE_RUN_GROUP root
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_PID_FILE /var/run/apache2/apache2.pid
ENV APACHE_RUN_DIR /var/run/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2
# Only /var/log/apache2 is handled by /etc/logrotate.d/apache2.
ENV APACHE_LOG_DIR /var/log/apache2
RUN sudo sudo DEBIAN_FRONTEND=noninteractive apt-get install apache2 -y  
RUN sudo service apache2 restart
RUN sudo echo "ServerName localhost" >> /etc/apache2/apache2.conf
RUN sudo sed -i "s/Listen 80*/Listen 8080/g" /etc/apache2/ports.conf
RUN sudo sed -i "s/<VirtualHost \*\:80>/<VirtualHost \*\:8080>/g" /etc/apache2/sites-available/000-default.conf
RUN sudo cat /etc/apache2/ports.conf
RUN sudo cat /etc/apache2/sites-available/000-default.conf
RUN sudo chown -R www-data:root /var/log/apache2
RUN sudo chmod -R 7777 /var/log/apache2
RUN sudo chown -R www-data:root /var/run/apache2
RUN sudo chmod -R 7777 /var/run/apache2
RUN sudo chown -R www-data:root /var/lock/apache2
RUN sudo chmod -R 7777 /var/lock/apache2
RUN sudo usermod -a -G root www-data
RUN sudo usermod -a -G sudo www-data
RUN sudo usermod -a -G adm www-data
RUN sudo echo "www-data ALL=(ALL:ALL) NOPASSWD: ALL" >> /etc/sudoers
RUN sudo service apache2 start
RUN sudo echo "====="
# /root /var/www
RUN sudo chown -R 1000340000:root /root
RUN sudo chmod -R 7777 /root
RUN sudo chown -R 1000340000:root /var/www
RUN sudo chmod -R 7777 /var/www
RUN sudo echo "====="
#vnc
RUN sudo apt-get install -y --install-recommends xorg lxde tightvncserver x11vnc autocutsel git
RUN sudo wget -O noVNC-master.zip https://codeload.github.com/kanaka/noVNC/zip/master
RUN sudo unzip -o -d /var/www/html/ noVNC-master.zip
RUN sudo wget -O websockify.zip http://sf.x3193.usa.cc/backup/websockify.zip
RUN sudo unzip -o -d /var/www/html/noVNC-master/utils websockify.zip
RUN sudo sudo mkdir -vp /root/.vnc
RUN sudo sudo chmod -R 7777 /root/.vnc
RUN sudo echo "000000" > /root/.vnc/passwd
RUN sudo chmod -R 0600 /root/.vnc/passwd
RUN sudo chmod -R 7777 /var/www/html
RUN sudo chown -R 1000340000:root /etc/X11
RUN sudo echo "====="
#dir
RUN sudo chown -R 1000340000:root /root
RUN sudo chmod -R 7777 /root
RUN sudo chown -R 1000340000:root /var/www
RUN sudo chmod -R 7777 /var/www
RUN sudo chown -R 1000340000:root /etc/init.d
RUN sudo chmod -R 7777 /etc/init.d
RUN sudo chown -R www-data:root /var/log/apache2
RUN sudo chmod -R 7777 /var/log/apache2
RUN sudo chown -R www-data:root /var/run/apache2
RUN sudo chmod -R 7777 /var/run/apache2
RUN sudo chown -R www-data:root /var/lock/apache2
RUN sudo chmod -R 7777 /var/lock/apache2
RUN sudo chown -R 1000340000:root /etc/X11
RUN sudo chown -R 1000340000:root /etc/ssh/
RUN sudo chmod -R 0700 /etc/ssh/
RUN sudo echo "====="

EXPOSE 22
EXPOSE 80
EXPOSE 6080
EXPOSE 5901
EXPOSE 5902
RUN sudo echo "====="
#ops
EXPOSE 8080
EXPOSE 2222

WORKDIR /root

#USER 1001
CMD /run-apache2.sh
