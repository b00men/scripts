#!/bin/bash

/usr/bin/stopvideo
mkdir /root/backup
mv /home/pi/.config/autostart/video.desktop /root/backup/
mv /etc/init.d/videoloop /root/backup/

wget http://adasm.com/published/videoplayer/videoplayer.tar.gz
tar -zxvf videoplayer.tar.gz
rm -rf videoplayer.tar.gz
chmod -R 777 videoplayer/
rm -rf /home/pi/videoplayer/
mv videoplayer/ /home/pi/videoplayer/
echo "cd /home/pi/videoplayer/" >> /home/pi/.bashrc
echo "./videoplayer" >> /home/pi/.bashrc

sed -i 's/^1:2345/#1:2345/' /etc/inittab
sed -i '/1:2345/a \1:2345:respawn:\/bin\/login\ -f\ pi\ tty1\ <\/dev\/tty1\ >\/dev\/tty1\ 2>&1' /etc/inittab

sed -i 's/^\(.\)/f1-\1/' /etc/hostname

cat install_videoplayer.sh | grep "# " | grep -v "grep"

# Дополнительно в raspi-config :
# 1) Выставляем видеопамять = 256мб.
# Или так ( echo "gpu_mem=256" >> /boot/config.txt )
#
# 2) Отключаем запуск DE, выбираем консольный режим.
# 
# 3) В /etc/inittab
# Комментируем строку "1:2345:respawn:/sbin/getty --noclear 38400 tty1"
# и вставляем после неё
# 1:2345:respawn:/bin/login -f pi tty1 </dev/tty1 >/dev/tty1 2>&1

