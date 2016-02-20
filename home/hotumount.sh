#!/bin/sh

# Полностью отмонтировать устройство /dev/sdb,
# остановить диск, послать сигнал на отключение устройства,
# вывестии сообщение о разрешении на вынимание диска.
# При ошибке на любом из этапов прекратить работу и
# вывести ошибку.

# todo:
# аргументы, notify, интеграция

mntstr=`mount | grep sdb | sed 's_\(/dev/sdb.\) \(.*\)_\1_'`

if [ -b /dev/sdb ] ; then
	if [ -n "$mntstr" ] ; then
		for i in "$mntstr"
		do
			sudo umount $i || exit
		done
	fi
	sync
	sudo scsi_stop /dev/sdb || exit
	sudo sh -c " echo 1 > /sys/block/sdb/device/delete" || exit
	echo "Complete prepare for hot umount /dev/sdb,\n	now device can be unplug."
else
	echo "/dev/sdb don't exist."
fi

