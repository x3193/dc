FROM ubuntu:trusty
MAINTAINER Honglin Feng <hfeng@tutum.co> 

# Install packages
RUN dpkg --configure -a && apt-get install -f && apt-get update && DEBIAN_FRONTEND=noninteractive apt-get -y install sudo net-tools openssh-server pwgen zip unzip python-numpy python3-numpy cron
RUN mkdir -p /var/run/sshd && sed -i "s/UsePrivilegeSeparation.*/UsePrivilegeSeparation no/g" /etc/ssh/sshd_config && sed -i "s/UsePAM.*/UsePAM no/g" /etc/ssh/sshd_config && sed -i "s/PermitRootLogin.*/PermitRootLogin yes/g" /etc/ssh/sshd_config

ADD set_root_pw.sh /set_root_pw.sh
ADD run.sh /run.sh
RUN chmod +x /*.sh

#---
LABEL io.openshift.expose-services="8080:http"
ADD /.s2i/bin/ /usr/local/s2i
# Drop the root user and make the content of /opt/app-root owned by user 1001
#RUN chown -R 1001:1001 /opt/app-root
RUN echo "1001 ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers;echo "Defaults visiblepw" >> /etc/sudoers
# Set the default user for the image, the user itself was created in the base image
USER 1001
#---

ENV AUTHORIZED_KEYS **None**

EXPOSE 22
CMD ["/run.sh"]
