#!/bin/sh
cd /var/www/info/
/var/www/info/./hdd.sh # Domain and hard drive status

ftphome='/home/b00men/ftp/other/*' # Move from ftphome to ftpdir (ftp share)
ftpdir='/srv/ftp/other/'
if [ -e $ftphome ] 
then
mv $ftphome $ftpdir
chmod 777 -R $ftpdir
fi

svn update --username b00men --password Adnimus /home/b00men/svn-4read/ >> /dev/null
