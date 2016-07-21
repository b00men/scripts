#!/bin/sh

# Старый плохой скрипт установки нового трафика на голую машину
# todo: Объединить с new_traffic.sh и auto_install_old_dexp

uservpn=login
passvpn=password
export PATH=$PATH:/usr/bin/:/usr/sbin/
sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config
sed -i 's/deb cdrom/#deb cdrom/' /etc/apt/sources.list
apt-get update && apt-get install -y git mpd mpc ncmpc rsync pptp-linux php5-cli ntp ntpdate mc  alsa-base alsa-tools tzdata tzdata-java lftp alsa-utils
mkdir /root/.ssh
cd /root/.ssh
wget http://marketradio.ru/id_rsa.pub
wget http://marketradio.ru/id_rsa
wget http://marketradio.ru/known_hosts
chmod 400 /root/.ssh/id_rsa
chmod 444 /root/.ssh/id_rsa.pub
chmod 644 /root/.ssh/known_hosts
chown -hR root:root /root/.ssh
git clone git@gitlab.com:a-s-dorohin/audio.git /opt/chroot/ && /opt/chroot/install
sed -i 's/mppe required,stateless/require-mppe/' /etc/ppp/peers/head
sed -i 's/\/usr\/bin\/getmusic\\n/\/usr\/bin\/getmusic\\n*\/10 * * * * \/usr\/bin\/checkconnect\\n/' /opt/service/libs/configs.py
echo "# Secrets for authentication using CHAP" > /etc/ppp/chap-secrets
echo "# client	server	secret			IP addresses" >> /etc/ppp/chap-secrets
echo "$uservpn	PPTP	$passvpn" >> /etc/ppp/chap-secrets
sed -i "s/login/$uservpn/" /etc/ppp/peers/head

# Один из способов размьютить и поднять мастер, требует доработки
#/usr/bin/amixer -q sset Master playback 54 && /usr/sbin/alsactl store
echo "check alsamixer & alsactl store"
