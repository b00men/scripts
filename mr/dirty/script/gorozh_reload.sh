#!/bin/bash
# 
cat /etc/hosts | grep gorozh | awk '{print $2}' > gorozh.list
for i in `cat gorozh.list`
do
  echo "lets reload $i !"
  ssh $i 'getmusic; sleep 15; /opt/market.php'
done

exit 0
