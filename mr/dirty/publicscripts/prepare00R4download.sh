#!/bin/bash
cat /work/\`PL0* | sed 's/\x0D$//' | grep 00R | sort -u > /tmp/00R.list
rm -f -r /tmp/00R4download
mkdir /tmp/00R4download
for i in `cat /tmp/00R.list`
do
        cp "/work/$i" /tmp/00R4download/
done
