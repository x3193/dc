#FROM ubuntu:xenial
FROM ubuntu:trusty
#FROM x3193/dc:latest
MAINTAINER x3193.usa.cc <x3193@x3193.usa.cc> 
 
ENV DEBIAN_FRONTEND noninteractive
ENV HOME /root
ENV USER root
ENV AUTHORIZED_KEYS **None**
ENV ROOT_PASS EUIfgwe7
ENV UBUNTUVER trusty
#ENV APPNAME opsv3
ENV APPNAME x3193
ENV BUILDLEV base
RUN echo "-------------------ENV install----------------"
ENV OPSUID 1068700000

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
RUN { [ "${BUILDLEV}" = "base" || "${BUILDLEV}" = "full" ] && sudo sh /var/www/html/shell/setup/this/vnc-wine.sh ${UBUNTUVER} "nowine"  || echo "" ; }
RUN { [ "${BUILDLEV}" = "base" || "${BUILDLEV}" = "full" ] && sudo sh /var/www/html/shell/setup/this/u7php.sh ${UBUNTUVER}  || echo "" ; }

RUN echo "==========="

ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_PID_FILE /var/run/apache2/apache2.pid
ENV APACHE_RUN_DIR /var/run/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2
# Only /var/log/apache2 is handled by /etc/logrotate.d/apache2.
ENV APACHE_LOG_DIR /var/log/apache2

ADD run$( [ ${APPNAME} = "x3193" ] &&  echo "" || echo "-".${APPNAME} ).sh /run$( [ ${APPNAME} = "x3193" ] &&  echo "" || echo "-".${APPNAME} ).sh
RUN chmod -R 7777 /run$( [ ${APPNAME} = "x3193" ] &&  echo "" || echo "-".${APPNAME} ).sh
RUN sh /set_root_pw.sh
RUN { [ "${BUILDLEV}" = "start" || "${BUILDLEV}" = "full"  ] && sudo sh /var/www/html/shell/cloud/opsv3/${APPNAME}.sh ${BUILDLEV} || echo "" ; }
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

USER root
#USER 1001

#CMD /run.sh full
#CMD run-opsv3.sh
CMD { [ ${APPNAME} = "x3193" ] && /run.sh full || /run-${APPNAME}.sh ; }
