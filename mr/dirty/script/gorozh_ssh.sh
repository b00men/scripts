#!/bin/bash
# 
cat /etc/hosts | grep gorozh | awk '{print $2}' > gorozh.list 
for i in `cat gorozh.list`
do
  echo "lets work with $i !"
  #sudo ssh $i 'cat /work/\`PL01.m3u | sed /YABLOKY_EKLERY/d > /tmp/pl01.tmp ; cp /work/\`PL01.m3u /root/pl01.bak; cp /tmp/pl01.tmp /work/\`PL01.m3u'
  sudo ssh $i 'mpc;/opt/market.php;mpc'
done

exit 0
