FROM ubuntu:trusty
MAINTAINER Honglin Feng <hfeng@tutum.co> 

# Install packages
RUN dpkg --configure -a && apt-get install -f && apt-get update && DEBIAN_FRONTEND=noninteractive apt-get -y install sudo net-tools openssh-server pwgen zip unzip python-numpy python3-numpy cron
RUN mkdir -p /var/run/sshd && sed -i "s/UsePrivilegeSeparation.*/UsePrivilegeSeparation no/g" /etc/ssh/sshd_config && sed -i "s/UsePAM.*/UsePAM no/g" /etc/ssh/sshd_config && sed -i "s/PermitRootLogin.*/PermitRootLogin yes/g" /etc/ssh/sshd_config

ADD set_root_pw.sh /set_root_pw.sh
ADD run.sh /run.sh
RUN chmod +x /*.sh

#---
RUN sudo mkdir -vp /var/www/html
ADD shell /var/www/html/shell
RUN chmod -R +x /var/www/html/shell
RUN echo "---------------------------SSH-----------------"  ;cd /var/www/html/shell/conf ;sudo rm -rf ~/.ssh;ssh-keygen -t rsa -f ~/.ssh/id_rsa -q -N "";cd /var/www/html/shell/conf/.ssh  ;sudo cp -R -f known_hosts id_rsa.pub id_rsa authorized_keys default.ppk ~/.ssh ;sudo chmod -R 0600 ~/.ssh ;sudo chmod 0700 ~ ;sudo chmod 0700 ~/.ssh ;sudo chmod 0644 ~/.ssh/authorized_keys ;sudo mkdir -vp ~/ssh;sudo cp -R -f ~/.ssh/* ~/ssh;cd /var/www/html/shell/conf/ssh ;sudo cp -R -f ssh /etc/init.d ;echo "=================================================";
#---
LABEL io.openshift.expose-services="8080:http,22:tcp"
RUN echo "1001 ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers;echo "Defaults visiblepw" >> /etc/sudoers
# Set the default user for the image, the user itself was created in the base image
USER 1001
#---

ENV AUTHORIZED_KEYS **None**
ENV PASS_ROOT EUIfgwe7

EXPOSE 22
EXPOSE 80
EXPOSE 6080
EXPOSE 5901
EXPOSE 5902
EXPOSE 8080

CMD ["/run.sh"]
