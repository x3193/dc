FROM ubuntu:14.04.2
 
ENV DEBIAN_FRONTEND noninteractive
ENV HOME /root
ENV USER root
ENV AUTHORIZED_KEYS **None**
ENV ROOT_PASS EUIfgwe7

# Install packages
RUN dpkg --configure -a && apt-get install -f && apt-get update && DEBIAN_FRONTEND=noninteractive apt-get -y install expect sudo openssh-server python-numpy python3-numpy
#RUN dpkg --configure -a && apt-get install -f && apt-get update && DEBIAN_FRONTEND=noninteractive apt-get -y install sudo net-tools openssh-server pwgen zip unzip python-numpy python3-numpy cron
RUN mkdir -p /var/run/sshd && sed -i "s/UsePrivilegeSeparation.*/UsePrivilegeSeparation no/g" /etc/ssh/sshd_config && sed -i "s/UsePAM.*/UsePAM no/g" /etc/ssh/sshd_config && sed -i "s/PermitRootLogin.*/PermitRootLogin yes/g" /etc/ssh/sshd_config

RUN adduser --shell /bin/bash --system --ingroup root --force-badname --uid 1001 ops
RUN echo "ops ALL=(ALL:ALL) NOPASSWD: ALL" >> /etc/sudoers
RUN echo "Defaults visiblepw" >> /etc/sudoers
RUN usermod -a -G sudo ops
RUN usermod -a -G adm ops
RUN echo "1007870000 ALL=(ALL:ALL) NOPASSWD: ALL" >> /etc/sudoers

ADD run-apache2.sh /run-apache2.sh
RUN chmod a+x /run-apache2.sh

RUN chown -R 1007870000:root /etc/ssh/
RUN chmod -R 0700 /etc/ssh/
RUN echo "AllowUsers ops 1007870000" >> /etc/ssh/sshd_conf
RUN sed -i "s/Port 22*/Port 2222/g" /etc/ssh/sshd_config

RUN service ssh restart
RUN cat /etc/ssh/sshd_config
RUN cat /etc/ssh/sshd_conf

EXPOSE 2222
USER 1007870000
CMD /run-apache2.sh
