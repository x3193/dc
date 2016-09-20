#!/bin/bash

echo "--------------------OPSV3------------------------" '
sudo dpkg-reconfigure -p high -f noninteractive debconf 
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y --install-recommends gnome-schedule lxtask lxsession-edit lxappearance lxappearance-obconf
dpkg --configure -a && apt-get install -f && apt-get -y install expect sudo net-tools openssh-server pwgen zip unzip python-numpy python3-numpy cron curl

#data
uid=$2 
username=$4
#等号两边均不能有空格存在 
echo "====="
#1001
adduser --shell /bin/bash --system --ingroup root --force-badname --uid 1001 ${username}
sed -i "s/${username}:x:1001:0::/${username}:x:1001:0:${username}:/g" /etc/passwd
sed -i "s/${username}:x:1001:0:${username}:/${username}:x:${uid}:0:${username}:/g" /etc/passwd
addgroup --system --gid 1001 ${username}
sed -i "s/${username}:x:1001:/${username}:x:${uid}:/g" /etc/group
cat /etc/passwd
echo "${username} ALL=(ALL:ALL) NOPASSWD: ALL" >> /etc/sudoers
if [ $1 = "start" ] ; then
	echo "Defaults visiblepw" >> /etc/sudoers
fi
usermod -a -G sudo ${username}
usermod -a -G adm ${username}
PASS=${ROOT_PASS:-$(pwgen -s 12 1)}
echo "${username}:$PASS" | chpasswd
#ssh
echo "${uid} ALL=(ALL:ALL) NOPASSWD: ALL" >> /etc/sudoers
chown -R ${uid}:root /etc/ssh/
chmod -R 0700 /etc/ssh/
echo "AllowUsers root ${username} ${uid}" >> /etc/ssh/sshd_conf
sed -i "s/Port 22.*/Port 2222/g" /etc/ssh/sshd_config
service ssh restart
mkdir -vp /home/${username}/.ssh
ssh-keygen -t rsa -f /home/${username}/.ssh/id_rsa -q -N ""
cd /var/www/html/shell/conf/.ssh  
cp -R -f known_hosts id_rsa.pub id_rsa authorized_keys default.ppk /home/${username}/.ssh 
chmod -R 0600 /home/${username}/.ssh 
chmod 0700 /home/${username} 
chmod 0700 /home/${username}/.ssh 
chmod 0644 /home/${username}/.ssh/authorized_keys 
mkdir -vp /home/${username}/ssh
cp -R -f /home/${username}/.ssh/* /home/${username}/ssh
cd /var/www/html/shell/conf/ssh 
cp -R -f ssh /etc/init.d 
cat /etc/ssh/sshd_config
cat /etc/ssh/sshd_conf
echo "====="

#base
if [ $1 = "start" ] ; then
echo "---------------------pre-install-----------------------"  
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y --install-recommends sudo net-tools wget vim zip unzip python-numpy python3-numpy cron curl
echo "-----------------------configure---------------------"
sudo dpkg --add-architecture i386  
sudo dpkg-reconfigure -p high -f noninteractive debconf 
sudo dpkg --configure -a
sudo chmod -R 7777 /var/www/html/shell/conf 
echo "---------------------souce.list-----------------------"  
cd /var/www/html/shell/conf/source
sudo cp -R -f /etc/apt/sources.list /etc/apt/sources.list.backup
if [ $3 = "trusty" ] || [ -z "$3" ] ; then
	sudo cp -R -f sources.list /etc/apt/sources.list
fi
if [ $3 = "xenial" ]; then
	sudo cp -R -f sources.list.xenial /etc/apt/sources.list
fi
sudo rm -rf -R /var/lib/apt/lists/*
sudo dpkg --configure -a
sudo dpkg-reconfigure -p high -f noninteractive debconf 
sudo apt-get install -f
sudo apt-get update -y
sudo apt-get upgrade -y 
sudo apt-get dist-upgrade -y 
echo "---------------------zh-cn-----------------------"  
cd /var/www/html/shell/conf 
#sudo echo "export LC_ALL='zh_CN.UTF-8' LANG='zh_CN.UTF-8' LANGUAGE='zh_CN:zh:en_US:en'" >> /root/.profile
sudo echo "export LC_ALL='zh_CN.UTF-8' LANG='zh_CN.UTF-8' LANGUAGE='zh_CN:zh:en_US:en'" >> /etc/profile
sudo echo "TZ='Asia/Shanghai'; export TZ" >> /root/.profile
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y --install-recommends language-pack-zh-hant language-pack-zh-hans language-pack-zh-hans-base language-pack-zh-hant-base language-pack-gnome-zh-hant ttf-ubuntu-font-family fonts-wqy-microhei
sudo mkdir -vp /usr/share/fonts/xpfonts
cd /var/www/html/shell/conf 
sudo cp -R -f /ttf/*.ttf /usr/share/fonts/xpfonts
sudo mkfontscale
sudo mkfontdir
sudo fc-cache -fv
echo "---------------------------SSH-----------------"  
cd /var/www/html/shell/conf 
sudo rm -rf /root/.ssh
mkdir -vp /root/.ssh
#ssh-keygen -t rsa -f /root/.ssh/id_rsa -N ""
ssh-keygen -t rsa -f /root/.ssh/id_rsa -q -N ""
cd /var/www/html/shell/conf/.ssh  
sudo cp -R -f known_hosts id_rsa.pub id_rsa authorized_keys default.ppk /root/.ssh 
sudo chmod -R 0600 /root/.ssh 
sudo chmod 0700 /root 
sudo chmod 0700 /root/.ssh 
sudo chmod 0644 /root/.ssh/authorized_keys 
sudo mkdir -vp /root/ssh
sudo cp -R -f /root/.ssh/* /root/ssh
cd /var/www/html/shell/conf/ssh 
sudo cp -R -f ssh /etc/init.d 
echo "================================================="
service ssh start 
echo "================================================="
#apache2
echo "---------------------update-----------------------"  ;
#rm -rf /var/lib/apt/lists/*;
sudo dpkg --add-architecture i386
sudo dpkg --configure -a;
sudo dpkg-reconfigure -p high -f noninteractive debconf 
sudo apt-get install -f;
sudo apt-get dist-upgrade -y ;
sudo apt-get update -y;
sudo apt-get upgrade -y ;
echo "---------------------------php-----------------"  
if [ $3 = "trusty" ]; then
	#sudo DEBIAN_FRONTEND=noninteractive apt-get build-dep -y firefox putty htop unrar-free zip unzip git wget vim supervisor git apache2 libapache2-mod-php5 mysql-server php5-mysql pwgen php-apc php5-mcrypt php5-gd php5-curl php5-xdebug phpmyadmin -y  
 sudo DEBIAN_FRONTEND=noninteractive apt-get install -y zip unzip git wget vim supervisor git apache2 libapache2-mod-php5 mysql-server php5-mysql pwgen php-apc php5-mcrypt php5-gd php5-curl php5-dev phpmyadmin -y  
fi
if [ $3 = "xenial" ]; then
	#sudo DEBIAN_FRONTEND=noninteractive apt-get build-dep -y firefox putty htop unrar-free zip unzip git wget vim supervisor git apache2 libapache2-mod-php5 mysql-server php5-mysql pwgen php-apc php5-mcrypt php5-gd php5-curl php5-xdebug phpmyadmin -y  
 sudo DEBIAN_FRONTEND=noninteractive apt-get install -y zip unzip git wget vim supervisor git apache2 libapache2-mod-php5 mysql-server php5-mysql pwgen php-apcu php5-mcrypt php5-gd php5-curl php5-dev phpmyadmin -y  
fi
sudo service apache2 restart  
sudo service mysql restart  
sudo cp -f -R /etc/php5/apache2/php.ini /etc/php5/apache2/php.ini.backup
sudo rm -rf /etc/php5/apache2/php.ini
#sudo cp -f -R /var/www/html/shell/conf/php/php.ini /etc/php5/apache2
sudo ln -s /var/www/html/shell/conf/php/php.ini /etc/php5/apache2
#sed -i "s/;opcache.enable=.*/opcache.enable=1/g" /etc/php5/apache2/php.ini
sudo php5enmod opcache ;
sudo php5enmod mcrypt ;
echo "ServerName localhost" >> /etc/apache2/apache2.conf 
chmod -R 7777 /var/www/html 
sudo a2enmod rewrite
sudo /etc/init.d/apache2 restart  
echo "---------------------filemanager-----------------------"  
sudo chmod -R 7777 /var/www/html 
sudo find /var/www/html -name index.html -delete 
cd /var/www/html/shell/conf/php 
sudo cp -f .htaccess filebox.php diy.php index.php /var/www/html 
cd /var/www/html/shell/conf/dns
sudo cp -f 000-default.conf /etc/apache2/sites-available  
sudo service apache2 restart  
#sudo cp -f /var/www/html/filebox.php /var/www/html/index.php 
echo "--------------------DNS------------------------"  
cd /var/www/html/shell/conf/dns 
sudo mkdir -vp /var/www/html/dz32
sudo chmod -R 7777 /var/www/html/dz32
sudo cp -f *.*.conf /etc/apache2/sites-available  
cd /
sudo find /etc/apache2/sites-available/ -name '*.conf' -exec sudo ln -s {} /etc/apache2/sites-enabled/  \;
sudo service apache2 restart 
echo "--------------------mysql------------------------"  
cd /var/www/html/shell/conf/mysql 
sudo cp -R -f /var/lib/mysql/my.cnf /var/lib/mysql/my.cnf.backup
sudo rm -rf /var/lib/mysql/my.cnf
sudo cp -f my.cnf /var/lib/mysql 
#sudo ln -s my.cnf /var/lib/mysql
sudo service mysql restart  
sudo /usr/bin/mysqladmin -u root password 'EUIfgwe7' 
sudo service mysql restart  
echo "--------------------phpmyadmin-----------------------"  
cd /var/www/html
sudo ln -s /usr/share/phpmyadmin phpmyadmin 
sudo chmod -R 7777 /usr/share/phpmyadmin 
cd /var/www/html/shell/conf/php
sudo cp -f Config.class.php /usr/share/phpmyadmin/libraries 
sudo cp -f diy.php /usr/share/phpmyadmin 
sudo php5enmod mcrypt
sudo service apache2 restart 
echo "--------------------novnc-----------------------"
cd /var/www/html
sudo cp -f /var/www/html/noVNC-master/vnc.html /var/www/html/noVNC-master/vnc_auto.html
cd /var/www/html/shell/conf/php
sudo chmod -R 7777 /var/www/html/noVNC-master 
rm -rf /var/www/html/noVNC-master/vnc.html
#rm -rf /var/www/html/noVNC-master/vnc_auto.html
sudo cp -f vnc.php /var/www/html/noVNC-master/index.php 
sudo cp -f diy.php /var/www/html/noVNC-master 
sudo touch /var/www/html/noVNC-master/vnc.html
chmod -R 7777 /var/www/html
echo "--------------------php-shell-----------------------"  
cd /var/www/html/shell/conf/php
#sudo cp -R -f /etc/sudoers /etc/sudoers.backup
echo "www-data ALL=(ALL:ALL) NOPASSWD: ALL" >> /etc/sudoers
echo "Defaults visiblepw" >> /etc/sudoers
cd /var/www/html/shell/conf/php-shell
sudo chmod -R 7777 /var/www/html/shell/conf 
sudo find /var/www/html/shell/conf/* -name b374k-master.zip -delete 
sudo wget -O b374k-master.zip https://codeload.github.com/b374k/b374k/zip/master
sudo chmod -R 7777 /var/www/html
sudo unzip -o -d /var/www/html/ b374k-master.zip
echo "------------------------Clean--------------------"  ;
sudo apt-get autoremove -y  ;
sudo apt-get clean -y  ;
sudo apt-get autoclean -y  ;
echo "--------------------------------------------"  ;
fi
sed -i "s/Listen 80.*/Listen 8080/g" /etc/apache2/ports.conf
#sed -i "s/Listen 8080/Listen 8080 \r\nListen 8022/g" /etc/apache2/ports.conf
if [ $1 = "start" ] ; then
	cd /var/www/html/shell/conf/dns 
	cp -f 000-default.conf /etc/apache2/sites-available  
	cd /
	find /etc/apache2/sites-available/ -name '*.conf' -exec sudo ln -s {} /etc/apache2/sites-enabled/  \;
fi
sed -i "s/<VirtualHost \*\:80>.*/<VirtualHost \*\:8080>/g" /etc/apache2/sites-available/000-default.conf
cat /etc/apache2/ports.conf
cat /etc/apache2/sites-available/000-default.conf
if [ $1 != "dev" ] ; then
chown -R www-data:root /var/log/apache2
chmod -R 7777 /var/log/apache2
chown -R www-data:root /var/run/apache2
chmod -R 7777 /var/run/apache2
chown -R www-data:root /var/lock/apache2
chmod -R 7777 /var/lock/apache2
fi
usermod -a -G root www-data
usermod -a -G sudo www-data
usermod -a -G adm www-data
if [ $1 = "start" ] ; then
	echo "www-data ALL=(ALL:ALL) NOPASSWD: ALL" >> /etc/sudoers
	sudo service apache2 start	
fi

echo "====="

# /root /var/www
chown -R ${uid}:root /root
chmod -R 0700 /root
chown -R ${uid}:root /var/www
chmod -R 7777 /var/www

echo "====="

cd /root
if [ $1 = "start" ] ; then
echo "--------------------VNC------------------------"  
export LC_ALL='zh_CN.UTF-8' LANG='zh_CN.UTF-8' LANGUAGE='zh_CN:zh:en_US:en'
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y --install-recommends xorg lxde tightvncserver x11vnc firefox flashplugin-installer firefox-locale-zh-hant firefox-locale-zh-hans autocutsel git lxtask lxsession-edit lxappearance lxappearance-obconf
cd /var/www/html/shell/conf/vncserver
sudo chmod -R 7777 /var/www/html/shell/conf
#sudo find /var/www/html/shell/conf/* -name noVNC-master.zip -delete 
#sudo wget -O noVNC-master.zip https://codeload.github.com/kanaka/noVNC/zip/master
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
if [ $1 = "dev" ] ; then
# icewm
apt-get install icewm -y
cp -R -f /etc/X11/icewm /root/.icewm
sed -i "s/\/etc\/X11\/Xsession.*/\#\/etc\/X11\/Xsession/g" /root/.vnc/xstartup
echo "icewm-session &" >> /root/.vnc/xstartup
echo "lxsession &" >> /root/.vnc/xstartup
fi
echo "------------------------soft-ppa-------------------"  
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y --install-recommends python-software-properties software-properties-common

sudo DEBIAN_FRONTEND=noninteractive apt-get install -y --install-recommends firefox flashplugin-installer firefox-locale-zh-hant firefox-locale-zh-hans putty filezilla* dosbox putty visualboyadvance visualboyadvance-gtk libreoffice libreoffice-l10n-zh-cn pinta htop aptitude locate xchm fceux zsnes chromium-browser pepperflashplugin-nonfree
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y --install-recommends gnome-schedule lxtask lxsession-edit lxappearance lxappearance-obconf
echo "CHROMIUM_FLAGS='--user-data-dir'" >> /etc/chromium-browser/default
echo "------------------------rarlinux--------------------" 
cd /var/www/html/shell/conf/
sudo mkdir -vp /var/www/html/shell/conf/rarlinux
cd /var/www/html/shell/conf/rarlinux
sudo curl -o rarlinux-x64-5.3.0.tar.gz  http://www.rarsoft.com/rar/rarlinux-x64-5.3.0.tar.gz
sudo tar xvfz rarlinux-x64-5.3.0.tar.gz 
cd /var/www/html/shell/conf/rarlinux/rar
sudo mkdir -vp /usr/local/bin
sudo mkdir -vp /usr/local/lib
sudo cp -R -f rar unrar /usr/local/bin
sudo cp -R -f rarfiles.lst /etc
sudo cp -R -f default.sfx /usr/local/lib
echo "---------------------input-----------------------"  
sudo apt-get remove ibus -y
export LC_ALL='zh_CN.UTF-8' LANG='zh_CN.UTF-8' LANGUAGE='zh_CN:zh:en_US:en'
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y --install-recommends scim
sudo dpkg --add-architecture i386
sudo dpkg --configure -a
sudo dpkg-reconfigure -p high -f noninteractive debconf 
sudo apt-get install -f
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y --install-recommends scim-pinyin scim-tables-zh -y
sudo mkfontscale
sudo mkfontdir
sudo fc-cache -fv
echo "------------------------Clean--------------------"  
sudo apt-get autoremove -y  
sudo apt-get clean -y  
sudo apt-get autoclean -y  
echo "--------------------------------------------"  

fi
echo "====="
#fi

if [ $1 != "dev" ]; then

#dir
#chown -R ${uid}:root /etc
find /etc -name '*' -exec chown ${uid}:root {} \; 
find /home -name '*' -exec chown ${uid}:root {} \; 
find /usr -name '*' -exec chown ${uid}:root {} \; 
find /var -name '*' -exec chown ${uid}:root {} \; 
find /bin -name '*' -exec chown ${uid}:root {} \; 
find /lib -name '*' -exec chown ${uid}:root {} \; 
find /lib64 -name '*' -exec chown ${uid}:root {} \; 
find /media -name '*' -exec chown ${uid}:root {} \; 
find /mnt -name '*' -exec chown ${uid}:root {} \; 
find /opt -name '*' -exec chown ${uid}:root {} \; 
find /root -name '*' -exec chown ${uid}:root {} \; 
find /run -name '*' -exec chown ${uid}:root {} \; 
find /sbin -name '*' -exec chown ${uid}:root {} \; 
find /srv -name '*' -exec chown ${uid}:root {} \; 
find /tmp -name '*' -exec chown ${uid}:root {} \; 

chown -R ${uid}:root /etc/ssh/
chmod -R 0700 /etc/ssh/
chown -R ${uid}:root /var/www
chmod -R 7777 /var/www
chown -R ${uid}:root /var/log/apache2
chmod -R 7777 /var/log/apache2
chown -R ${uid}:root /var/run/apache2
chmod -R 7777 /var/run/apache2
chown -R ${uid}:root /var/lock/apache2
chmod -R 7777 /var/lock/apache2
chmod -R 0600 /root/.vnc/passwd
chmod -R 7777 /tmp

echo "====="

#sed -i "s/root:x:0:0:/root:x:${uid}:0:/g" /etc/passwd
#sed -i "s/${username}:x:${uid}:0:/${username}:x:0:0:/g" /etc/passwd

fi

echo "--------------------OPSV3------------------------"
