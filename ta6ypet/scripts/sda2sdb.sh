cp /mnt/backups/all_db.sql /mnt/backups/all_db_second.sql

rsync -a -q -v --force --delete --max-delete=1000 \
/mnt/bacup_root_1/ \
--exclude="- boot/" \
--exclude="- etc/fstab" \
/mnt/bacup_root_2
