#!/bin/bash

echo "--------------------OPSV3------------------------" 
uid=$2 
#等号两边均不能有空格存在 
echo "====="
#input
export INPUTRC=/etc/inputrc
#cp -R -f /var/www/html/shell/cloud/opsv3/conf/inputrc /etc
#cp -R -f /var/www/html/shell/cloud/opsv3/conf/inputrc-rh /etc/inputrc
#1001
adduser --shell /bin/bash --system --ingroup root --force-badname --uid 1001 x3193
sed -i "s/x3193:x:1001:0::/x3193:x:1001:0:x3193:/g" /etc/passwd
sed -i "s/x3193:x:1001:0:x3193:/x3193:x:${uid}:0:x3193:/g" /etc/passwd
addgroup --system --gid 1001 x3193
sed -i "s/x3193:x:1001:/x3193:x:${uid}:/g" /etc/group
cat /etc/passwd
echo "x3193 ALL=(ALL:ALL) NOPASSWD: ALL" >> /etc/sudoers
if [ $1 = "start" ] ; then
	echo "Defaults visiblepw" >> /etc/sudoers
fi
usermod -a -G sudo x3193
usermod -a -G adm x3193
echo "x3193:${ROOT_PASS}" | chpasswd
#ssh
echo "${uid} ALL=(ALL:ALL) NOPASSWD: ALL" >> /etc/sudoers
chown -R ${uid}:root /etc/ssh/
chmod -R 0700 /etc/ssh/
echo "AllowUsers root x3193 ${uid}" >> /etc/ssh/sshd_conf
sed -i "s/Port 22.*/Port 2222/g" /etc/ssh/sshd_config
service ssh restart
mkdir -vp /home/x3193/.ssh
ssh-keygen -t rsa -f /home/x3193/.ssh/id_rsa -q -N ""
cd /var/www/html/shell/conf/.ssh  
cp -R -f known_hosts id_rsa.pub id_rsa authorized_keys default.ppk /home/x3193/.ssh 
chmod -R 0600 /home/x3193/.ssh 
chmod 0700 /home/x3193 
chmod 0700 /home/x3193/.ssh 
chmod 0644 /home/x3193/.ssh/authorized_keys 
mkdir -vp /home/x3193/ssh
cp -R -f /home/x3193/.ssh/* /home/x3193/ssh
cd /var/www/html/shell/conf/ssh 
cp -R -f ssh /etc/init.d 
cat /etc/ssh/sshd_config
cat /etc/ssh/sshd_conf
echo "====="

#if [ $1 = "full" ] ; then
if [ $1 = "start" ] ; then
	#apache2
	DEBIAN_FRONTEND=noninteractive apt-get install apache2 -y  
	service apache2 restart
	echo "ServerName localhost" >> /etc/apache2/apache2.conf
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
chmod -R 0700 /var/log/apache2
chown -R www-data:root /var/run/apache2
chmod -R 0700 /var/run/apache2
chown -R www-data:root /var/lock/apache2
chmod -R 0700 /var/lock/apache2
fi
usermod -a -G root www-data
usermod -a -G sudo www-data
usermod -a -G adm www-data
if [ $1 = "start" ] ; then
	echo "www-data ALL=(ALL:ALL) NOPASSWD: ALL" >> /etc/sudoers
fi
service apache2 start
echo "====="
if [ $1 = "start" ] ; then
# /root /var/www
chown -R ${uid}:root /root
chmod -R 0700 /root
chown -R ${uid}:root /var/www
chmod -R 0700 /var/www
fi
echo "====="
#vnc
cd /root
if [ $1 = "start" ] ; then
apt-get install -y --install-recommends xorg lxde tightvncserver x11vnc autocutsel git
chmod -R 7777 /var/www/html/shell/conf 
cd /var/www/html/shell/conf/vncserver
#sudo find /var/www/html/shell/conf/* -name noVNC-master.zip -delete 
#sudo wget -O noVNC-master.zip https://codeload.github.com/kanaka/noVNC/zip/master
sudo mkdir -vp /var/www/html
sudo chmod -R 7777 /var/www/html
sudo unzip -o -d /var/www/html/ noVNC-master.zip
sudo chmod -R 7777 /var/www/html
sudo unzip -o -d /var/www/html/noVNC-master/utils websockify.zip
mkdir -vp /root/.vnc
chmod -R 7777 /root/.vnc
chmod -R 7777 /var/www/html
cd /var/www/html/shell/conf/vncserver 
cp -R -f passwd xstartup /root/.vnc
chmod -R 0600 /root/.vnc/passwd
if [ $1 = "dev" ] ; then
# icewm
apt-get install icewm -y
cp -R -f /etc/X11/icewm /root/.icewm
sed -i "s/\/etc\/X11\/Xsession.*/\#\/etc\/X11\/Xsession/g" /root/.vnc/xstartup
echo "icewm-session &" >> /root/.vnc/xstartup
echo "lxsession &" >> /root/.vnc/xstartup
fi
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
chmod -R 0700 /var/www
chown -R www-data:root /var/log/apache2
chmod -R 0700 /var/log/apache2
chown -R www-data:root /var/run/apache2
chmod -R 0700 /var/run/apache2
chown -R www-data:root /var/lock/apache2
chmod -R 0700 /var/lock/apache2
chmod -R 0600 /root/.vnc/passwd
chmod -R 7777 /tmp

echo "====="

#sed -i "s/root:x:0:0:/root:x:${uid}:0:/g" /etc/passwd
#sed -i "s/x3193:x:${uid}:0:/x3193:x:0:0:/g" /etc/passwd

fi

echo "--------------------OPSV3------------------------"
