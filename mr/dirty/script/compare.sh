#!/bin/sh
cat test | while read i ; do
cat test2 | while read j ; do
echo "ololo'$j'ololo"
echo "ololo'$i'ololo"
if [ "$i" = "$j" ]
then
echo "EQ!"
else
echo "no"
fi
done
done
