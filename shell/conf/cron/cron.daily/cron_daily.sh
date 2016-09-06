#!/bin/bash
SHELL=/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin

echo "--------------------------------------------" >> /root/cron.log;
sudo dpkg --configure -a
#sudo apt-get update ;
#sudo apt-get upgrade -y ;
#sudo apt-get dist-upgrade -y ;
rm -rf /var/lib/apt/lists/*;
rm -rf /tmp/*;
echo "Update ok!" >> /root/cron.log;

#pgrep scim-im-agent | xargs -I {} kill {}
pgrep ssh-agent | xargs -I {} kill {}
pgrep chromium-browse | xargs -I {} kill {}
echo "Clean ok!" >> /root/cron.log;

if [ $1 = "full" ] || [ $1 = "vnc" ]; then
 sudo tightvncserver -kill :1
fi
export LC_ALL='zh_CN.UTF-8' LANG='zh_CN.UTF-8' LANGUAGE='zh_CN:zh:en_US:en'
TZ='Asia/Shanghai'; export TZ
if [ $1 = "full" ] || [ $1 = "vnc" ]; then
 sudo tightvncserver :1
fi

echo "Restart ok!" >> /root/cron.log;

echo $(date) >> /root/cron.log;
echo "--------------------------------------------" >> /root/cron.log;