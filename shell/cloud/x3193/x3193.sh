#!/bin/bash

echo "--------------------X3193 update------------------------" 
sudo dpkg-reconfigure -p high -f noninteractive debconf 

sudo DEBIAN_FRONTEND=noninteractive apt-get install -y --install-recommends gnome-schedule lxtask lxsession-edit lxappearance lxappearance-obconf
curl -sSL https://get.daocloud.io/docker | sh

echo "--------------------VNC------------------------"  
#export LC_ALL='zh_CN.UTF-8' LANG='zh_CN.UTF-8' LANGUAGE='zh_CN:zh:en_US:en'
#sudo DEBIAN_FRONTEND=noninteractive apt-get build-dep -y --install-recommends xorg lxde tightvncserver gtk2-engines-murrine autocutsel git
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y --install-recommends xorg lxde tightvncserver x11vnc autocutsel git 
cd /var/www/html/shell/conf/vncserver
sudo chmod -R 7777 /var/www/html/shell/conf
sudo find /var/www/html/shell/conf/* -name noVNC-master.zip -delete 
sudo wget -O noVNC-master.zip https://codeload.github.com/kanaka/noVNC/zip/master
sudo mkdir -vp /var/www/html
sudo chmod -R 7777 /var/www/html
sudo unzip -o -d /var/www/html/ noVNC-master.zip
sudo chmod -R 7777 /var/www/html
sudo unzip -o -d /var/www/html/noVNC-master/utils websockify.zip
sudo mkdir -vp /root/.vnc
sudo chmod -R 7777 /root/.vnc
cd /var/www/html/shell/conf/vncserver 
sudo cp -R -f passwd xstartup /root/.vnc 
sudo chmod -R 0600 /root/.vnc/passwd
#setsid autocutsel &
echo "================================================="
if [ -z "$1"]; then
 tightvncserver -kill :1
 tightvncserver :1
 setsid /var/www/html/noVNC-master/utils/launch.sh --vnc localhost:5901 & 
fi 
echo "================================================="