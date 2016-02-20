#!/bin/sh
### BEGIN INIT INFO
# Provides:	     bash
# Required-Start:    $local_fs
# Required-Stop:     $local_fs
# Default-Start:     S
# Default-Stop:      0 6
# Short-Description: sync dir in /var/log for tmpfs
# Description:       Create dir in /var/log on tmpfs for stable logging and save listdir /var/log on poweroff for forvading sync.
### END INIT INFO

# Author: Nikita Shchipachev <b00men@pochta.ru>

RETVAL=0

case "$1" in
start)
for i in `cat /home/b00men/.vardir`;
do mkdir $i;
done
for i in `cat /home/b00men/.vardir`;
do chmod 775 $i;
done
chown -R Debian-exim /var/log/exim4
chmod 650 /var/log/exim4
chown root:utmp /var/log/wtmp
chown root:utmp /var/log/utmp
chown root:utmp /var/log/btmp
chown mysql:adm /var/log/mysql
chmod 664 /var/log/wtmp
chmod 664 /var/log/utmp
chmod 664 /var/log/btmp
chmod 750 /var/log/mysql
touch /var/log/lastlog
chmod 664 /var/log/lastlog
rsync -rq --max-size=1 --min-size=2 /var/www_hard/ /var/www/
mount --bind /var/www_hard/forum/media/uploads /var/www/forum/media/uploads
rsync -aq /var/www_hard/* --exclude="- /var/www/forum/media/uploads" /var/www/
RETVAL=$?
;;
stop)
ls /var/log/*/ -d > /home/b00men/.vardir
umount /var/www/forum/media/uploads
RETVAL=$?
;;
*)
echo "Usage: svnserve {start|stop}"
exit 1
;;
esac
exit $RETVAL
