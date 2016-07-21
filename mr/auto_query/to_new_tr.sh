#!/bin/bash 

# Исполняет последовательность комманд (./new_traffic.sh в
# неинтерактивном режиме, обновляет базу, перезапускает плеер,
# перезагружает сервер) на незакомментированных хостах из $TARGET.
# При успешном исполнении комментирует отработанную строчку в $TARGET
# и ждет подтверждения для продолжения. При ошибке останавливается.
#
# Удобно для быстрого но детально отслеживаемого перехода большого
# массива машин на новый трафик.
# Заранее на все машины копируется скрипт new_traffic.sh.
# Список хостов разбивается на несколько групп
# (напр.: target1.list, ... , target4.list).
# Колличеству групп соответствует количество копий этого скрипта,
# где в каждой копии свой $TARGET.
# Параллельное исполнение (при необходисости - многократное)
# в нескольких окнах этих копий позволяет прозрачно видеть
# процесс установки и обновления на каждой машине,
# не прерывая процесса вмешиваться и исправлять ошибки,
# лично убеждаться в готовности каждого сервера.

TARGET="target.list"

# TARGET - файл со списком хостов для перехода на новый трафик.

if [[ `whoami` != "root" ]]
then
	echo You need to be root to perform this command. 
	exit 1
fi

MYPID=$BASHPID
cat $TARGET | grep -v "^#" > /tmp/newtr_tmp.$MYPID.list

for k in `cat /tmp/newtr_tmp.$MYPID.list`
do
	echo ""
	echo "Start $k:"
	ssh $k 'DEBIAN_FRONTEND=noninteractive ./new_traffic.sh && getmusic && sleep 10 && market && mpc && reboot' && sed -i "s/^\($k\)/#\1/" $TARGET || exit 1
	echo "$k end"
	echo -n "Press [Enter] to continue or [Ctrl+C] to stop"
	read
done

rm /tmp/newtr_tmp.$MYPID.list

exit 0