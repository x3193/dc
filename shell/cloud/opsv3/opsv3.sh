#!/bin/bash
 
echo "--------------------OPSV3------------------------" 
uid = $2
echo "====="
#input
export INPUTRC=/etc/inputrc
#echo "bind '\"^[[A\": history-search-backward'" >> /etc/inputrc
#echo "bind '\"^[[B\": history-search-forward'" >> /etc/inputrc
#1001
adduser --shell /bin/bash --system --ingroup root --force-badname --uid 1001 ops
echo "ops ALL=(ALL:ALL) NOPASSWD: ALL" >> /etc/sudoers
echo "Defaults visiblepw" >> /etc/sudoers
usermod -a -G sudo ops
usermod -a -G adm ops
#ssh
#echo "${uid} ALL=(ALL:ALL) NOPASSWD: ALL" >> /etc/sudoers
chown -R ${uid}:root /etc/ssh/
chmod -R 0700 /etc/ssh/
echo "AllowUsers ops ${uid}" >> /etc/ssh/sshd_conf
sed -i "s/Port 22.*/Port 2222/g" /etc/ssh/sshd_config
service ssh restart
cat /etc/ssh/sshd_config
cat /etc/ssh/sshd_conf
echo "====="

if [ $1 = "full" ]; then
#apache2
DEBIAN_FRONTEND=noninteractive apt-get install apache2 -y  
service apache2 restart
echo "ServerName localhost" >> /etc/apache2/apache2.conf
sed -i "s/Listen 80.*/Listen 8080/g" /etc/apache2/ports.conf
sed -i "s/<VirtualHost \*\:80>.*/<VirtualHost \*\:8080>/g" /etc/apache2/sites-available/000-default.conf
cat /etc/apache2/ports.conf
cat /etc/apache2/sites-available/000-default.conf
chown -R www-data:root /var/log/apache2
chmod -R 7777 /var/log/apache2
chown -R www-data:root /var/run/apache2
chmod -R 7777 /var/run/apache2
chown -R www-data:root /var/lock/apache2
chmod -R 7777 /var/lock/apache2
usermod -a -G root www-data
usermod -a -G sudo www-data
usermod -a -G adm www-data
echo "www-data ALL=(ALL:ALL) NOPASSWD: ALL" >> /etc/sudoers
service apache2 start
echo "====="
# /root /var/www
chown -R ${uid}:root /root
chmod -R 7777 /root
chown -R ${uid}:root /var/www
chmod -R 7777 /var/www
echo "====="
#vnc
cd /root
apt-get install -y --install-recommends xorg lxde tightvncserver x11vnc autocutsel git
wget -O noVNC-master.zip https://codeload.github.com/kanaka/noVNC/zip/master
unzip -o -d /var/www/html/ noVNC-master.zip
wget -O websockify.zip http://sf.x3193.usa.cc/backup/websockify.zip
unzip -o -d /var/www/html/noVNC-master/utils websockify.zip
mkdir -vp /root/.vnc
chmod -R 7777 /root/.vnc
chmod -R 7777 /var/www/html
apt-get install icewm -y
cp -r /etc/X11/icewm /root/.icewm
sed -i "s/\/etc\/X11\/Xsession.*/\#\/etc\/X11\/Xsession/g" /root/.vnc/xstartup
echo "icewm-session &" >> /root/.vnc/xstartup
echo "lxsession &" >> /root/.vnc/xstartup
echo "====="
fi

#dir
chown -R ${uid}:root /etc
chown -R ${uid}:root /usr
chown -R ${uid}:root /var
chown -R ${uid}:root /bin
chown -R ${uid}:root /lib
chown -R ${uid}:root /lib64
chown -R ${uid}:root /media
chown -R ${uid}:root /mnt
chown -R ${uid}:root /opt
chown -R ${uid}:root /root
chown -R ${uid}:root /run
chown -R ${uid}:root /sbin
chown -R ${uid}:root /srv
chown -R ${uid}:root /tmp

chown -R ${uid}:root /etc/ssh/
chmod -R 0700 /etc/ssh/
chown -R ${uid}:root /var/www
chmod -R 7777 /var/www
chown -R www-data:root /var/log/apache2
chmod -R 7777 /var/log/apache2
chown -R www-data:root /var/run/apache2
chmod -R 7777 /var/run/apache2
chown -R www-data:root /var/lock/apache2
chmod -R 7777 /var/lock/apache2
chown -R ${uid}:root /etc/X11
chmod -R 0600 /root/.vnc/passwd
chmod -R 7777 /tmp
echo "====="

echo "--------------------OPSV3------------------------"
