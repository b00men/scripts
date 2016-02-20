#!/bin/sh

# Костыль для очистки /work
# Проверен на разных платформах.
# SPACE - сколько свободных мб считать достаточным.
# TODEL - Сколько "ненужных" песен удалять за раз.

# Проверяет место в /work, если оно меньше $SPACE (mb), то найти
# "ненужные" песни (которых нет ни в одном текущем музыкальном листе),
# удалить из них первые $TODEL

# todo: (если он вообще нужен для костыля)
# цикл

SPACE=700
TODEL=100

free=`df -m | grep "/work" | awk '{print $4}'`
if [ $free -lt $SPACE ]
then
echo "Avalible $free Mb \n autoclean engaged:"
sed '$a\' /work/\`PL0* | sed -e '/00R/d' -e '/00P/d' -e '/FANTOM/d' -e '/TISHINA/d' | awk '{print "/work/"$0}' | tr -d '\r' | sort -u > /tmp/allplst
find $PWD /work/ | grep mp3 | sed -e '/00R/d' -e '/00P/d' -e '/FANTOM/d' -e '/TISHINA/d' > /tmp/allmzk
grep -F -v -f /tmp/allplst /tmp/allmzk > /tmp/todel
head -n $TODEL /tmp/todel | while read i
do
echo "delete $i"
rm "$i"
done
echo "Complete. Avalible `df -m | grep "/work" | awk '{print $4}'`Mb"
else
echo "Freespace is ok"
fi