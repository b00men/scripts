#!/bin/bash
sed -i 's/^deb\ cdrom/#\ deb\ cdrom/g' /etc/apt/sources.list
apt-get update && apt-get -y install mpd mpc ncmpc rsync pptp-linux php5-cli ntp ntpdate mc  alsa-base alsa-tools tzdata tzdata-java lftp alsa-utils
sed -i -e 's/\/usr\/bin\/vpnstart/#\/usr\/bin\/vpnstart/' -e 's/\/opt\/market\.php/#\/opt\/market\.php/' /etc/rc.local
sed -i 's/^exit\ 0$/\/usr\/bin\/vpnstart\n\/opt\/market.php\n\nexit\ 0/' /etc/rc.local

