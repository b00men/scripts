#!/bin/bash
# 

for i in `cat lama.list`
do
  echo "lets reload $i !"
  ssh $i 'getmusic; sleep 7; /opt/market.php' &
done

exit 0
