#!/bin/bash

echo "--------------------X3193 update------------------------" 

dpkg --configure -a && apt-get install -f && apt-get update && DEBIAN_FRONTEND=noninteractive apt-get -y install expect sudo net-tools openssh-server pwgen zip unzip python-numpy python3-numpy cron curl
mkdir -p /var/run/sshd && sed -i "s/UsePrivilegeSeparation.*/UsePrivilegeSeparation no/g" /etc/ssh/sshd_config && sed -i "s/UsePAM.*/UsePAM no/g" /etc/ssh/sshd_config && sed -i "s/PermitRootLogin.*/PermitRootLogin yes/g" /etc/ssh/sshd_config

sudo dpkg-reconfigure -p high -f noninteractive debconf 
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y --install-recommends gnome-schedule lxtask lxsession-edit lxappearance lxappearance-obconf

sudo dpkg --add-architecture i386
sudo dpkg --configure -a
sudo dpkg-reconfigure -p high -f noninteractive debconf 
sudo apt-get install -f
sudo apt-get update -y
sudo apt-get upgrade -y 
sudo apt-get dist-upgrade -y 

