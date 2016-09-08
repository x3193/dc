#!/bin/bash
 
echo "--------------------OPSV3------------------------" 
echo "====="
#input
echo "bind \'\"^[[A\": history-search-backward\'" >> ~/.bashrc
echo "bind \'\"^[[B\": history-search-forward\'" >> ~/.bashrc
#1001
adduser --shell /bin/bash --system --ingroup root --force-badname --uid 1001 ops
echo "ops ALL=(ALL:ALL) NOPASSWD: ALL" >> /etc/sudoers
echo "Defaults visiblepw" >> /etc/sudoers
usermod -a -G sudo ops
usermod -a -G adm ops
#ssh
#echo "1068700000 ALL=(ALL:ALL) NOPASSWD: ALL" >> /etc/sudoers
chown -R 1068700000:root /etc/ssh/
chmod -R 0700 /etc/ssh/
echo "AllowUsers ops 1068700000" >> /etc/ssh/sshd_conf
sed -i "s/Port 22*/Port 2222/g" /etc/ssh/sshd_config
service ssh restart
cat /etc/ssh/sshd_config
cat /etc/ssh/sshd_conf
echo "====="

if [ $1 = "full" ]; then
#apache2
DEBIAN_FRONTEND=noninteractive apt-get install apache2 -y  
service apache2 restart
echo "ServerName localhost" >> /etc/apache2/apache2.conf
sed -i "s/Listen 80*/Listen 8080/g" /etc/apache2/ports.conf
sed -i "s/<VirtualHost \*\:80>/<VirtualHost \*\:8080>/g" /etc/apache2/sites-available/000-default.conf
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
chown -R 1068700000:root /root
chmod -R 7777 /root
chown -R 1068700000:root /var/www
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
chown -R 1068700000:root /etc
chown -R 1068700000:root /usr
chown -R 1068700000:root /var
chown -R 1068700000:root /bin
chown -R 1068700000:root /lib
chown -R 1068700000:root /lib64
chown -R 1068700000:root /media
chown -R 1068700000:root /mnt
chown -R 1068700000:root /opt
chown -R 1068700000:root /root
chown -R 1068700000:root /run
chown -R 1068700000:root /sbin
chown -R 1068700000:root /srv
chown -R 1068700000:root /tmp

chown -R 1068700000:root /etc/ssh/
chmod -R 0700 /etc/ssh/
chown -R 1068700000:root /var/www
chmod -R 7777 /var/www
chown -R www-data:root /var/log/apache2
chmod -R 7777 /var/log/apache2
chown -R www-data:root /var/run/apache2
chmod -R 7777 /var/run/apache2
chown -R www-data:root /var/lock/apache2
chmod -R 7777 /var/lock/apache2
chown -R 1068700000:root /etc/X11
chmod -R 0600 /root/.vnc/passwd
chmod -R 7777 /tmp
echo "====="

echo "--------------------OPSV3------------------------"
