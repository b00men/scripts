#!/bin/bash
#
# Use with cron:
# 0 * * * * /bin/bash /$GIT_FOLDER/notes/.git_sync.sh
#
ROOT_PATH=$(cd $(dirname $0) && pwd);
cd $ROOT_PATH
git pull -q
git commit -a -m "auto commit from $HOSTNAME `date "+%D %R %z"`" --q
git push -q
