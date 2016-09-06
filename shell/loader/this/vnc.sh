#!/bin/bash
 
echo "--------------------VNC------------------------" 

sudo cron
sudo /etc/init.d/cron restart
sudo rm -rf -R /tmp/*
sudo chmod -R 7777 /var/www/html

if [ $1 = "full" ]; then
 sudo service apache2 restart ;
 sudo service ssh start ;
 sudo service mysql restart ;
 export LC_ALL='zh_CN.UTF-8' LANG='zh_CN.UTF-8' LANGUAGE='zh_CN:zh:en_US:en'
 TZ='Asia/Shanghai'; export TZ
 tightvncserver :1
 setsid /var/www/html/noVNC-master/utils/launch.sh --vnc localhost:5901 &
fi

if [ $1 = "vnc" ]; then
 #sudo service apache2 restart ;
 #sudo service ssh start ;
 #sudo service mysql restart ;
 export LC_ALL='zh_CN.UTF-8' LANG='zh_CN.UTF-8' LANGUAGE='zh_CN:zh:en_US:en'
 TZ='Asia/Shanghai'; export TZ
 tightvncserver :1
 setsid /var/www/html/noVNC-master/utils/launch.sh --vnc localhost:5901 &
fi

if [ $1 = "php" ]; then
 sudo service apache2 restart ;
 #sudo service ssh start ;
 #sudo service mysql restart ;
fi

if [ $1 = "php-full" ]; then
 sudo service apache2 restart ;
 #sudo service ssh start ;
 sudo service mysql restart ;
fi

echo "--------------------VNC------------------------"