#FROM ubuntu:xenial
FROM ubuntu:trusty
#FROM x3193/dc:latest
MAINTAINER x3193.tk <x3193@x3193.tk> 
 
ENV DEBIAN_FRONTEND noninteractive
ENV HOME /root
ENV USER root

# Install packages
RUN dpkg --configure -a && apt-get install -f && apt-get update && DEBIAN_FRONTEND=noninteractive apt-get -y install sudo net-tools openssh-server pwgen zip unzip python-numpy python3-numpy cron
RUN mkdir -p /var/run/sshd && sed -i "s/UsePrivilegeSeparation.*/UsePrivilegeSeparation no/g" /etc/ssh/sshd_config && sed -i "s/UsePAM.*/UsePAM no/g" /etc/ssh/sshd_config && sed -i "s/PermitRootLogin.*/PermitRootLogin yes/g" /etc/ssh/sshd_config

ADD set_root_pw.sh /set_root_pw.sh
ADD run.sh /run.sh
RUN chmod +x /*.sh
RUN chmod -R 7777 .s2i/bin

#RUN sh /ssh.sh
#RUN sh /set_root_pw.sh

ENV AUTHORIZED_KEYS **None**
ENV ROOT_PASS EUIfgwe7

EXPOSE 22
EXPOSE 80
EXPOSE 6080
EXPOSE 5901
EXPOSE 5902

WORKDIR /root

#RUN adduser --shell /bin/bash --system --ingroup root --force-badname --uid 1000 1001
RUN adduser --shell /bin/bash --system --ingroup root --force-badname 1001
RUN echo "1001 ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
RUN echo "Defaults visiblepw" >> /etc/sudoers
USER 1001

CMD ["sudo","sh","/run.sh"]

