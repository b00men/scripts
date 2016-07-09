#!/bin/sh
mntstr=`mount | grep sdb | awk '{print $3}' | tac`

if [ -b /dev/sdb ] ; then
	if [ -n "$mntstr" ] ; then
		for i in "$mntstr"
		do
			sudo umount -R $i || exit
		done
	fi
	sync
	sudo scsi_stop /dev/sdb || exit
	sudo sh -c " echo 1 > /sys/block/sdb/device/delete" || exit
	echo "Complete prepare for hot umount /dev/sdb,\n	now device can be ubplug."
else
	echo "/dev/sdb don't exist."
fi

