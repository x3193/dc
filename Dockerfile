FROM ubuntu:trusty
#FROM x3193/dc:latest
MAINTAINER x3193.tk <x3193@x3193.tk> 

ENV DEBIAN_FRONTEND noninteractive
ENV HOME /root
ENV USER root

# Install packages
RUN sudo dpkg --configure -a && sudo apt-get install -f && apt-get update && DEBIAN_FRONTEND=noninteractive apt-get -y install openssh-server pwgen zip unzip python-numpy python3-numpy
RUN mkdir -p /var/run/sshd && sed -i "s/UsePrivilegeSeparation.*/UsePrivilegeSeparation no/g" /etc/ssh/sshd_config && sed -i "s/UsePAM.*/UsePAM no/g" /etc/ssh/sshd_config && sed -i "s/PermitRootLogin.*/PermitRootLogin yes/g" /etc/ssh/sshd_config

ADD set_root_pw.sh /set_root_pw.sh
ADD run.sh /run.sh
RUN chmod +x /*.sh

RUN echo "-------------------Data install----------------"
ADD shell /root/shell
RUN chmod -R +x /root/shell
RUN sudo sh /root/shell/setup/this/vnc-wine.sh "docker"
#RUN sudo sh /root/shell/setup/this/u7php.sh
RUN echo "--------------------Data install---------------"

ENV AUTHORIZED_KEYS **None**
ENV ROOT_PASS EUIfgwe7

EXPOSE 22
EXPOSE 80
EXPOSE 6080
EXPOSE 5901
EXPOSE 5902

WORKDIR /root

CMD ["/run.sh"]
