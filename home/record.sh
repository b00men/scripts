#!/bin/bash

# Мгновенно начинает запись аудио в $DIR/[Дата]-L[Номер].mp3
# При существовании файлов с таким именем, увеличивает [Номер]
# Окончание записи с помощью Ctrl+C

DIR="/media/Data/REC/"
DATE=`date +%y%m%d`
declare -i NUM=1
FILENAME=`printf %s%02d%s $DATE-L $NUM .mp3`
while [ -a $DIR$FILENAME ]
do
	NUM=NUM+1
	FILENAME=`printf %s%02d%s $DATE-L $NUM .mp3`
done
echo "REC $FILENAME"
rec -c 2 -r 48000 -t WAV - | lame -h -b 320 - $DIR$FILENAME
