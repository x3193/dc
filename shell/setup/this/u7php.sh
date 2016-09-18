#!/bin/bash
 
echo "---------------------update-----------------------"  ;
rm -rf /var/lib/apt/lists/*;
sudo dpkg --configure -a;
sudo dpkg-reconfigure -p high -f noninteractive debconf 
sudo apt-get install -f;
sudo apt-get dist-upgrade -y ;
sudo apt-get update -y;
sudo apt-get upgrade -y ;
echo "---------------------------php-----------------"  
if [ $1 = "trusty" ]; then
	#sudo DEBIAN_FRONTEND=noninteractive apt-get build-dep -y firefox putty htop unrar-free zip unzip git wget vim supervisor git apache2 libapache2-mod-php5 mysql-server php5-mysql pwgen php-apc php5-mcrypt php5-gd php5-curl php5-xdebug phpmyadmin -y  
 sudo DEBIAN_FRONTEND=noninteractive apt-get install -y zip unzip git wget vim supervisor git apache2 libapache2-mod-php5 mysql-server php5-mysql pwgen php-apc php5-mcrypt php5-gd php5-curl php5-dev phpmyadmin -y  
fi
if [ $1 = "xenial" ]; then
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
