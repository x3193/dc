FROM ubuntu:trusty
MAINTAINER Honglin Feng <hfeng@tutum.co> 

# Install packages
RUN dpkg --configure -a && apt-get install -f && apt-get update && DEBIAN_FRONTEND=noninteractive apt-get -y install sudo net-tools openssh-server pwgen zip unzip python-numpy python3-numpy cron
RUN mkdir -p /var/run/sshd && sed -i "s/UsePrivilegeSeparation.*/UsePrivilegeSeparation no/g" /etc/ssh/sshd_config && sed -i "s/UsePAM.*/UsePAM no/g" /etc/ssh/sshd_config && sed -i "s/PermitRootLogin.*/PermitRootLogin yes/g" /etc/ssh/sshd_config

ADD set_root_pw.sh /set_root_pw.sh
ADD run.sh /run.sh
RUN chmod +x /*.sh

#---
LABEL io.openshift.expose-services="8080:http,22:tcp"
RUN echo "1001 ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers;echo "Defaults visiblepw" >> /etc/sudoers
#---
RUN sudo DEBIAN_FRONTEND=noninteractive apt-get install -y zip unzip git wget vim supervisor git apache2 libapache2-mod-php5 mysql-server php5-mysql pwgen php-apc php5-mcrypt php5-gd php5-curl php5-dev phpmyadmin -y 
RUN sudo php5enmod mcrypt
#---

ENV AUTHORIZED_KEYS **None**
ENV PASS_ROOT EUIfgwe7

EXPOSE 22
EXPOSE 80
EXPOSE 6080
EXPOSE 5901
EXPOSE 5902
EXPOSE 8080

USER 1001

#CMD ["/run.sh"]
