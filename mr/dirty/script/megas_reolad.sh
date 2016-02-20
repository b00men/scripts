#!/bin/bash
# 

for i in `cat megas.list`
do
  echo "lets reload $i !"
  ssh $i 'getmusic; /usr/bin/stopmusic; /opt/market.php; /usr/bin/playmusic' &
done

exit 0
