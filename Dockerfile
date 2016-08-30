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
RUN dpkg --configure -a && apt-get install -f && apt-get update && DEBIAN_FRONTEND=noninteractive apt-get -y install expect sudo openssh-server python-numpy python3-numpy
#RUN dpkg --configure -a && apt-get install -f && apt-get update && DEBIAN_FRONTEND=noninteractive apt-get -y install sudo net-tools openssh-server pwgen zip unzip python-numpy python3-numpy cron
RUN mkdir -p /var/run/sshd && sed -i "s/UsePrivilegeSeparation.*/UsePrivilegeSeparation no/g" /etc/ssh/sshd_config && sed -i "s/UsePAM.*/UsePAM no/g" /etc/ssh/sshd_config && sed -i "s/PermitRootLogin.*/PermitRootLogin yes/g" /etc/ssh/sshd_config

ADD set_root_pw.sh /set_root_pw.sh
ADD run.sh /run.sh
ADD exp.sh /exp.sh
ADD runexp.sh /runexp.sh
RUN chmod +x /*.sh

RUN sh /set_root_pw.sh

EXPOSE 22
EXPOSE 80
EXPOSE 6080
EXPOSE 5901
EXPOSE 5902
EXPOSE 8080

WORKDIR /root

RUN adduser --shell /bin/bash --system --ingroup root --force-badname --uid 1001 ops
#RUN echo "ops:EUIfgwe7" | chpasswd
RUN echo "ops ALL=(ALL:ALL) ALL" >> /etc/sudoers
#RUN echo "ops ALL=(ALL:ALL) NOPASSWD: ALL" >> /etc/sudoers
RUN echo "Defaults visiblepw" >> /etc/sudoers
#RUN sed -i "s/# auth       sufficient pam_wheel.so trust/auth       sufficient pam_wheel.so trust/g" /etc/pam.d/su
RUN usermod -a -G sudo ops
RUN usermod -a -G adm ops

#RUN adduser --shell /bin/bash --system --ingroup root --force-badname --uid 1005790000 x3193
#RUN echo "x3193 ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
#RUN usermod -a -G sudo x3193
#RUN usermod -a -G adm x3193
#RUN adduser --shell /bin/bash --lastuid 1005790000 --system --ingroup root --uid 1005790000 x3193
RUN echo "1007740000 ALL=(ALL:ALL) NOPASSWD: ALL" >> /etc/sudoers
RUN chown -R 1007740000:root /etc/init.d/ssh
RUN chmod -R 0700 /etc/init.d/ssh
RUN chown -R 1007740000:root /etc/ssh/
RUN chmod -R 0700 /etc/ssh/

USER 1001
#USER 0
#USER 1005790000

ENTRYPOINT echo "1111111"
CMD echo "2222222"
#ENTRYPOINT ["/run.sh", "-D", "FOREGROUND"]
#ENTRYPOINT ["/run.sh", "-D", "FOREGROUND"]
#CMD sh /runexp.sh
#CMD ["sudo","sh","/run.sh"]
#CMD ["/exp.sh"]
CMD ["/run.sh", "-D", "FOREGROUND"]
