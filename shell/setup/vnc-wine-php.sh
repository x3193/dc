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
sudo unzip -o -d /var/www/html/noVNC-master/utils websockify.zip
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
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y --force-yes --no-install-recommends firefox flashplugin-installer firefox-locale-zh-hant firefox-locale-zh-hans putty filezilla* dosbox putty visualboyadvance visualboyadvance-gtk libreoffice libreoffice-l10n-zh-cn pinta htop
echo "--------------------WINE1.6/8------------------------"  
sudo dpkg --configure -a
sudo apt-get install -f
sudo apt-get dist-upgrade -y 
sudo apt-get update -y
sudo apt-get upgrade -y 
sudo DEBIAN_FRONTEND=noninteractive apt-get build-dep -y --force-yes --install-recommends wine1.6
sudo dpkg --add-architecture i386
sudo dpkg --configure -a
sudo apt-get install -f
sudo apt-get dist-upgrade -y 
sudo apt-get update -y
sudo apt-get upgrade -y 
dpkg --print-architecture
dpkg --print-foreign-architectures
sudo dpkg --add-architecture i386
sudo DEBIAN_FRONTEND=noninteractive apt-get build-dep -y --force-yes --install-recommends wine1.6
sudo dpkg --add-architecture i386
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y --force-yes --install-recommends wine1.6
#sudo DEBIAN_FRONTEND=noninteractive apt-get build-dep -y --force-yes --install-recommends q4wine
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y --force-yes --install-recommends q4wine
# wine32
#env WINEARCH=win32 WINEPREFIX=~/.wine winecfg
# wine64
#env WINEARCH=win64 WINEPREFIX=~/.wine64 winecfg
echo "---------------------------php-----------------"  ;
#sudo DEBIAN_FRONTEND=noninteractive apt-get build-dep -y --force-yes firefox putty htop unrar-free zip unzip git wget vim supervisor git apache2 libapache2-mod-php5 mysql-server php5-mysql pwgen php-apc php5-mcrypt php5-gd php5-curl php5-xdebug phpmyadmin -y  ;
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y --force-yes zip unzip git wget vim supervisor git apache2 libapache2-mod-php5 mysql-server php5-mysql pwgen php-apc php5-mcrypt php5-gd php5-curl php5-xdebug phpmyadmin -y  ;
sudo service apache2 restart  ;
sudo service mysql restart  ;
sudo php5enmod mcrypt ;
echo "ServerName localhost" >> /etc/apache2/apache2.conf ;
chmod -R 7777 /var/www/html ;
sudo a2enmod rewrite ;
sudo /etc/init.d/apache2 restart  ;
echo "---------------------filemanager-----------------------"  ;
sudo chmod -R 7777 /var/www/html ;
sudo find /var/www/html -name index.html -delete ;
cd /var/www/html/opensource/ald ;
sudo cp -f .htaccess filebox.php diy.php /var/www/html ;
sudo cp -f 000-default.conf /etc/apache2/sites-available  ;
sudo service apache2 restart  ;
sudo cp -f /var/www/html/filebox.php /var/www/html/index.php ;
echo "--------------------DNS------------------------"  ;
cd /var/www/html/opensource/ald ;
sudo mkdir -vp /var/www/html/dz32;
sudo chmod -R 7777 /var/www/html/dz32;
sudo cp -f *.*.conf /etc/apache2/sites-available  ;
cd /
sudo find /etc/apache2/sites-available/ -name '*.conf' -exec sudo ln -s {} /etc/apache2/sites-enabled/  \;  ;
sudo service apache2 restart  ;
echo "--------------------mysql------------------------"  ;
cd /var/www/html/opensource/ald ;
sudo cp -f my.cnf /var/lib/mysql ;
sudo service mysql restart  ;
sudo /usr/bin/mysqladmin -u root password 'EUIfgwe7' ;
sudo service mysql restart  ;
echo "--------------------phpmyadmin-----------------------"  ;
cd /var/www/html;
sudo ln -s /usr/share/phpmyadmin phpmyadmin ;
sudo chmod -R 7777 /usr/share/phpmyadmin ;
cd /var/www/html/opensource/ald ;
sudo cp -f Config.class.php /usr/share/phpmyadmin/libraries ;
sudo cp -f diy.php /usr/share/phpmyadmin ;
sudo php5enmod mcrypt;
sudo service apache2 restart ;
sudo service mysql restart ;
echo "--------------------novnc-----------------------"  ;
cd /var/www/html;
sudo chmod -R 7777 /var/www/html/noVNC-master ;
cd /var/www/html/opensource/ald ;
rm -rf /var/www/html/noVNC-master/vnc.html;
rm -rf /var/www/html/noVNC-master/vnc_auto.html;
sudo cp -f vnc.php /var/www/html/noVNC-master/index.php ;
sudo cp -f diy.php /var/www/html/noVNC-master ;
echo "------------------------Clean--------------------"  
sudo apt-get autoremove -y  
sudo apt-get clean -y  
sudo apt-get autoclean -y  
echo "--------------------------------------------"  

