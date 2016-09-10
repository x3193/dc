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
ENV INPUTRC /etc/inputrc
# trusty xenial
ENV UBUNTUVER trusty 
# x3193 opsv3
ENV APPNAME opsv3 
# start base full mini
ENV BUILDLEV mini
# root 1068700000 
ENV UUID 1068700000 

# Install packages
RUN dpkg --configure -a && apt-get install -f && apt-get update && DEBIAN_FRONTEND=noninteractive apt-get -y install expect sudo net-tools openssh-server pwgen zip unzip python-numpy python3-numpy cron
RUN mkdir -p /var/run/sshd && sed -i "s/UsePrivilegeSeparation.*/UsePrivilegeSeparation no/g" /etc/ssh/sshd_config && sed -i "s/UsePAM.*/UsePAM no/g" /etc/ssh/sshd_config && sed -i "s/PermitRootLogin.*/PermitRootLogin yes/g" /etc/ssh/sshd_config

ADD set_root_pw.sh /set_root_pw.sh
ADD run.sh /run.sh
RUN chmod -R 7777 /*.sh

RUN echo "-------------------Data install----------------"

RUN sudo mkdir -vp /var/www/html
ADD shell /var/www/html/shell
RUN chmod -R 7777 /var/www/html/shell
RUN { { [ ${BUILDLEV} = "base" ] || [ ${BUILDLEV} = "full" ] ; } && sudo sh /var/www/html/shell/setup/this/vnc-wine.sh ${UBUNTUVER} "nowine" || echo "" ; }
RUN { { [ ${BUILDLEV} = "base" ] || [ ${BUILDLEV} = "full" ] ; } && sudo sh /var/www/html/shell/setup/this/u7php.sh ${UBUNTUVER} || echo "" ; }
#RUN sudo sh /var/www/html/shell/setup/this/vnc-wine.sh ${UBUNTUVER} "nowine"
#RUN sudo sh /var/www/html/shell/setup/this/u7php.sh ${UBUNTUVER}

RUN echo "==========="

ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_PID_FILE /var/run/apache2/apache2.pid
ENV APACHE_RUN_DIR /var/run/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2
# Only /var/log/apache2 is handled by /etc/logrotate.d/apache2.
ENV APACHE_LOG_DIR /var/log/apache2

#ADD run-${APPNAME}.sh /run-${APPNAME}.sh
#RUN chmod -R 7777 /run-${APPNAME}.sh
RUN { [ ${APPNAME} = "opsv3" ] && sh /set_root_pw.sh || echo "" ; } 
RUN { { { { [ ${BUILDLEV} = "start" ] && [ ${UUID} != "root" ] ; } || { [ ${BUILDLEV} = "full" ] && [ ${UUID} != "root" ] ; } ; } || { [ ${BUILDLEV} = "mini" ] && [ ${UUID} != "root" ] ; } ; } && sudo sh /var/www/html/shell/cloud/opsv3/${APPNAME}.sh ${BUILDLEV} ${UUID} ||  echo "" ; }

RUN echo "==========="

RUN echo "--------------------Config install---------------"

RUN echo "-------------------------------------------------"

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
USER ${UUID}

CMD { { [ ${APPNAME} = "x3193" ] || [ ${APPNAME} = "" ] ; } && /run.sh full || /run.sh full ${APPNAME} ; }
