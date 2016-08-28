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

# Install packages
RUN dpkg --configure -a && apt-get install -f && apt-get update && DEBIAN_FRONTEND=noninteractive apt-get -y install expect sudo net-tools openssh-server pwgen zip unzip python-numpy python3-numpy cron
#RUN dpkg --configure -a && apt-get install -f && apt-get update && DEBIAN_FRONTEND=noninteractive apt-get -y install sudo net-tools openssh-server pwgen zip unzip python-numpy python3-numpy cron
RUN mkdir -p /var/run/sshd && sed -i "s/UsePrivilegeSeparation.*/UsePrivilegeSeparation no/g" /etc/ssh/sshd_config && sed -i "s/UsePAM.*/UsePAM no/g" /etc/ssh/sshd_config && sed -i "s/PermitRootLogin.*/PermitRootLogin yes/g" /etc/ssh/sshd_config

ADD set_root_pw.sh /set_root_pw.sh
ADD run.sh /run.sh
ADD exp.sh /exp.sh
ADD runexp.sh /runexp.sh
RUN chmod +x /*.sh

RUN sh /set_root_pw.sh
#RUN whereis expect

EXPOSE 22
EXPOSE 80
EXPOSE 6080
EXPOSE 5901
EXPOSE 5902
EXPOSE 8080

WORKDIR /root

RUN adduser --shell /bin/bash --system --ingroup root --force-badname --uid 1001 ops
RUN echo "ops ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
RUN echo "Defaults visiblepw" >> /etc/sudoers
RUN sed -i "s/# auth       sufficient pam_wheel.so trust/auth       sufficient pam_wheel.so trust/g" /etc/pam.d/su
#RUN usermod -G root ops
#RUN adduser --shell /bin/bash --system --ingroup root --force-badname --uid 1005790000 x3193
#RUN echo "x3193 ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
USER 1001

CMD ["/runexp.sh"]
#CMD ["sudo","sh","/run.sh"]
#CMD ["/exp.sh"]
#CMD ["/run.sh"]
