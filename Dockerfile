#FROM ubuntu:xenial
FROM ubuntu:trusty
#FROM x3193/dc:latest
MAINTAINER x3193.usa.cc <x3193@x3193.usa.cc> 
 
ENV DEBIAN_FRONTEND noninteractive
ENV HOME /root
ENV USER root
ENV AUTHORIZED_KEYS **None**
ENV ROOT_PASS EUIfgwe7
RUN echo "-------------------ENV install----------------"
ENV LC_ALL zh_CN.UTF-8
ENV LANG zh_CN.UTF-8
ENV LANGUAGE zh_CN:zh:en_US:en
ENV TZ Asia/Shanghai

# Install packages
RUN dpkg --configure -a && apt-get install -f && apt-get update && DEBIAN_FRONTEND=noninteractive apt-get -y install expect sudo net-tools openssh-server pwgen zip unzip python-numpy python3-numpy cron
RUN mkdir -p /var/run/sshd && sed -i "s/UsePrivilegeSeparation.*/UsePrivilegeSeparation no/g" /etc/ssh/sshd_config && sed -i "s/UsePAM.*/UsePAM no/g" /etc/ssh/sshd_config && sed -i "s/PermitRootLogin.*/PermitRootLogin yes/g" /etc/ssh/sshd_config

ADD set_root_pw.sh /set_root_pw.sh
ADD run.sh /run.sh
RUN chmod +x /*.sh

RUN echo "-------------------Data install----------------"

#root pw
#RUN sh /set_root_pw.sh
#ADD run-opsv3.sh /run-opsv3.sh
#RUN chmod a+x /run-opsv3.sh

#ENV APACHE_RUN_USER ops
#ENV APACHE_RUN_GROUP root
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_PID_FILE /var/run/apache2/apache2.pid
ENV APACHE_RUN_DIR /var/run/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2
# Only /var/log/apache2 is handled by /etc/logrotate.d/apache2.
ENV APACHE_LOG_DIR /var/log/apache2

##RUN sudo mkdir -vp /var/www/html
##ADD shell /var/www/html/shell
##RUN chmod -R +x /var/www/html/shell
##RUN sudo sh /var/www/html/shell/setup/this/vnc-wine.sh "trusty" "nowine"
##RUN sudo sh /var/www/html/shell/setup/this/u7php.sh "trusty"
##RUN sudo sh /var/www/html/shell/cloud/opsv3/opsv3.sh


RUN echo "--------------------Data install---------------"

EXPOSE 22
EXPOSE 80
EXPOSE 6080
EXPOSE 5901
EXPOSE 5902
RUN echo "====="
#ops
EXPOSE 8080
EXPOSE 2222
EXPOSE 3377

WORKDIR /root

#USER root
USER 1000340000
#USER 1001

CMD ["/run.sh","full"]
