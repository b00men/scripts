#!/bin/sh
free=`df -m | grep "/work" | awk '{print $4}'`
if [ $free -lt 700 ]
then
echo "Avalible $free Mb \n autoclean engaged:"
sed '$a\' /work/\`PL0* | sed -e '/00R/d' -e '/00P/d' -e '/FANTOM/d' -e '/TISHINA/d' | awk '{print "/work/"$0}' | tr -d '\r' | sort -u > /tmp/allplst
find $PWD /work/ | grep mp3 | sed -e '/00R/d' -e '/00P/d' -e '/FANTOM/d' -e '/TISHINA/d' > /tmp/allmzk
grep -F -v -f /tmp/allplst /tmp/allmzk > /tmp/todel
head -n 100 /tmp/todel | while read i
do
echo "delete $i"
rm "$i"
done
echo "Complete. Avalible `df -m | grep "/work" | awk '{print $4}'`Mb"
else
echo "Freespace is ok"
fi
