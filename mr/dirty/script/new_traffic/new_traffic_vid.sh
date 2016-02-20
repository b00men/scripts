#!/bin/sh
export PATH=$PATH:/usr/bin/:/usr/sbin/
crontab -l > /root/crontab.bak
cp /etc/ppp/chap-secrets /root/chap-secrets.bak
cp /etc/ppp/peers/head /root/head.bak
rm /etc/mpd.conf
apt-get update && apt-get install -y git mpd mpc ncmpc rsync pptp-linux php5-cli ntp ntpdate mc  alsa-base alsa-tools tzdata tzdata-java lftp alsa-utils
cd /root/.ssh
wget http://marketradio.ru/id_rsa.pub
wget http://marketradio.ru/id_rsa
#wget http://marketradio.ru/known_hosts
chmod 400 /root/.ssh/id_rsa
chmod 444 /root/.ssh/id_rsa.pub
#chmod 644 /root/.ssh/known_hosts
chown -hR root:root /root/.ssh/id_rsa*
mv /opt/service /opt/service_old
echo "StrictHostKeyChecking no" >> /root/.ssh/config
git clone git@gitlab.com:a-s-dorohin/audio.git /opt/chroot/ && /opt/chroot/install
sed -i 's/^StrictHostKeyChecking no/#StrictHostKeyChecking no/' /root/.ssh/config
cp /root/chap-secrets.bak /etc/ppp/chap-secrets
cp /root/head.bak /etc/ppp/peers/head
#sed -i 's/\/opt\/market.php/#\/opt\/market.php/' /etc/rc.local
#sed -i 's/#        device                  "hw:0,0"/        device                  "hw:0,0"/' /etc/mpd.conf
sed -i 's/\/usr\/bin\/getmusic\\n/\/usr\/bin\/getmusic\\n*\/10 * * * * \/usr\/bin\/checkconnect\\n5 5 * * * \/sbin\/reboot\\n/' /opt/service/libs/configs.py
sed -i 's/\/usr\/bin\/playmusic/\/bin\/true/' /opt/service/libs/configs.py
sed -i 's/\/usr\/bin\/stopmusic/\/bin\/true/' /opt/service/libs/configs.py
#echo Напоминание.\nНе забудьте просмотреть /root/crontab.bak и при необходимости поправить /opt/service/lib/config.py!

