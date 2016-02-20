#!/bin/sh
mount -U d383d889-98ba-4f32-967f-20427180f87f /backup
date
snapshot_dir="/backup/snapshot/`date \+\%Y_\%m_\%d`"
mkdir $snapshot_dir
rsync -a -h --delete --max-delete=1000 --hard-links \
  --delete-excluded --exclude=/home/b00men/Downloads/* \
  --exclude=/srv/ftp/* --exclude=/dev/ --exclude=/proc/ \
  --exclude=/lost+found/ --exclude=/backup/ --exclude=/40GB/ \
  --exclude=/sys/ --exclude=/var/cache/ --exclude=/mnt/ \
  --backup --backup-dir=$snapshot_dir \
  / /backup/latest

RETCODE=$?
if [ $RETCODE -ne 0 ]; then
    echo "Err code=$RETCODE"
fi
echo RET: $RETCODE
#/bin/chmod 0700 /media/data/.backups/latest
#/bin/chmod 0700 /media/data/.backups/snapshot
umount /backup
