YEAR=`date +%Y`
MONTH=`date +%m`
DAY=`date +%d`
BACKUP_DIR="/mnt/backups"
SNAPSHOT_DIR="$BACKUP_DIR/days/$YEAR/$MONTH/$DAY"

# backup mysql
cp $BACKUP_DIR/all_db.sql $BACKUP_DIR/all_db_prev.sql
mysqldump -E -u root -pAdnimus --all-databases > $BACKUP_DIR/all_db.sql

# Stoping services
service mysql stop
service nginx stop
service postgresql stop

# Start backup RSYNC
rsync -a -q -v --force --delete --max-delete=1000 \
--backup --backup-dir=$SNAPSHOT_DIR \
/mnt/nowroot/ \
$BACKUP_DIR/now 

rsync -a -q -v --force --delete --max-delete=1000 \
$BACKUP_DIR/now/ \
--exclude="- boot/" \
--exclude="- etc/fstab" \
/mnt/bacup_root_1

# Starting services
service mysql start
service nginx start
service postgresql start
