#!/bin/bash
# 

for i in `cat gorozh.list`
do
  echo "lets look $i !"
  ssh $i 'df -h /work'
done

exit 0
