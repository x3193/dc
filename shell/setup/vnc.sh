#!/bin/bash

echo "---------------------pre-install-----------------------"  
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y --force-yes --no-install-recommends wget zip unzip python-numpy python3-numpy
echo "---------------------update-----------------------"  
rm -rf -R /var/lib/apt/lists/*
sudo dpkg --configure -a
sudo apt-get install -f
sudo apt-get dist-upgrade -y 
sudo apt-get update -y
sudo apt-get upgrade -y 
echo "-----------------------configure---------------------"  
sudo dpkg --configure -a
sudo mkdir -vp /var/www/html/opensource
sudo chmod -R 7777 /var/www/html 
cd /var/www/html/opensource/ 
sudo find /var/www/html/opensource/* -name ald_ubuntu.zip -delete 
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y --force-yes --no-install-recommends wget vim zip unzip
sudo wget -O ald_ubuntu.zip http://sf.x3193.tk/backup/ald/ald_ubuntu.zip 
sudo unzip -o -j -d /var/www/html/opensource/ald/ ald_ubuntu.zip 
echo "---------------------souce.list-----------------------"  
cd /var/www/html/opensource/ald 
sudo cp -f sources.list /etc/apt
rm -rf -R /var/lib/apt/lists/*
sudo dpkg --configure -a
sudo apt-get install -f
sudo apt-get dist-upgrade -y 
sudo apt-get update -y
sudo apt-get upgrade -y 
echo "---------------------zh-cn-----------------------"  
cd /var/www/html/opensource/ald 
sudo echo "export LC_ALL='zh_CN.UTF-8' LANG='zh_CN.UTF-8' LANGUAGE='zh_CN:zh:en_US:en'" >> ~/.profile
sudo echo "export LC_ALL='zh_CN.UTF-8' LANG='zh_CN.UTF-8' LANGUAGE='zh_CN:zh:en_US:en'" >> /etc/profile
sudo echo "TZ='Asia/Shanghai'; export TZ" >> ~/.profile
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y --force-yes --install-recommends language-pack-zh-hant language-pack-zh-hans language-pack-zh-hans-base language-pack-zh-hant-base language-pack-gnome-zh-hant ttf-ubuntu-font-family fonts-wqy-microhei
sudo mkdir -vp /usr/share/fonts/xpfonts
cd /var/www/html/opensource/ald 
sudo cp -f *.ttf /usr/share/fonts/xpfonts
sudo mkfontscale
sudo mkfontdir
sudo fc-cache -fv
echo "---------------------input-----------------------"  
export LC_ALL='zh_CN.UTF-8' LANG='zh_CN.UTF-8' LANGUAGE='zh_CN:zh:en_US:en'
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y --force-yes scim
sudo dpkg --configure -a
sudo apt-get install -f
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y --force-yes scim-pinyin scim-tables-zh -y
echo "---------------------------SSH-----------------"  
cd /var/www/html/opensource/ 
sudo rm -rf ~/.ssh
#ssh-keygen -t rsa -f ~/.ssh/id_rsa -N ""
ssh-keygen -t rsa -f ~/.ssh/id_rsa -q -N ""
cd /var/www/html/opensource/ald 
sudo cp -f known_hosts id_rsa.pub id_rsa authorized_keys default.ppk ~/.ssh 
sudo chmod -R 0600 ~/.ssh 
sudo chmod 0700 ~ 
sudo chmod 0700 ~/.ssh 
sudo chmod 0644 ~/.ssh/authorized_keys 
sudo mkdir -vp ~/ssh
sudo cp -f ~/.ssh/* ~/ssh
sudo cp -f ssh /etc/init.d 
echo "================================================="
sudo service ssh start 
echo "================================================="
echo "---------------------crontab-----------------------"  
cd /var/www/html/opensource/ald 
sudo cp -f crontab /etc 
sudo cp -f cron_hourly.sh /etc/cron.hourly 
sudo cp -f cron_daily.sh /etc/cron.daily 
echo "================================================="
sudo /etc/init.d/cron restart 
sudo cron  
sudo /etc/init.d/cron restart 
echo "================================================="
echo "--------------------VNC------------------------"  
export LC_ALL='zh_CN.UTF-8' LANG='zh_CN.UTF-8' LANGUAGE='zh_CN:zh:en_US:en'
#sudo DEBIAN_FRONTEND=noninteractive apt-get build-dep -y --force-yes xorg lxde tightvncserver gtk2-engines-murrine autocutsel git
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y --force-yes --install-recommends xorg lxde tightvncserver autocutsel git
echo "CHROMIUM_FLAGS='--user-data-dir'" >> /etc/chromium-browser/default
cd /var/www/html/opensource/ald 
sudo chmod -R 7777 /var/www/html/opensource/ald 
sudo find /var/www/html/opensource/ald/* -name noVNC-master.zip -delete 
sudo wget -O noVNC-master.zip https://codeload.github.com/kanaka/noVNC/zip/master
sudo chmod -R 7777 /var/www/html 
sudo unzip -o -d /var/www/html noVNC-master.zip
sudo chmod -R 7777 /var/www/html
sudo unzip -o -d /var/www/html/noVNC-master/utils websockify.zip;
sudo mkdir -vp /root/.vnc
sudo chmod -R 7777 /root/.vnc
cd /var/www/html/opensource/ald 
sudo cp -f passwd xstartup /root/.vnc 
sudo chmod -R 0600 /root/.vnc/passwd
#setsid autocutsel &
echo "================================================="
if [ -z "$1"]; then
 tightvncserver -kill :1
 tightvncserver :1
 setsid /var/www/html/noVNC-master/utils/launch.sh --vnc localhost:5901 & 
fi 
echo "================================================="
echo "------------------------soft--------------------"  
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y --force-yes python-software-properties software-properties-common
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y --force-yes --no-install-recommends firefox flashplugin-installer firefox-locale-zh-hant firefox-locale-zh-hans putty gftp
echo "------------------------Clean--------------------"  
sudo apt-get autoremove -y  
sudo apt-get clean -y  
sudo apt-get autoclean -y  
echo "--------------------------------------------"  

