#!/bin/bash
for i in `ls playlist*.zip`
do
unar -f $i
done
