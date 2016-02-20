#!/bin/bash 

# Обновляет эфир старого трафика на хостах из hosts,
# включающих в своем названии слово, переданное первым аргументом.
# Если аргумент не передан, то на всех, кроме traffic|votan|snm|head
# Например, ./reload_list.sh gorozhanka исполнит запрос на всех горожанках.
# Запускается после выгрузки.

parallel=0

# parallel
# 0 - обычный режим "по-очереди", удобно анализировать.
# 1 - быстрый и грубый параллельный режим, ответ нечитабелен.

# Требуем права рута для возможности подключения по ключу.
if [[ `whoami` != "root" ]]
then
	echo You need to be root to perform this command. 
	exit 1
fi

# Прогоняем скрипт для обработки выгрузки.
echo -n "Mover in process..."
if [ -z `/usr/bin/php /opt/mover/index.php 1>&2` ]
then echo " OK"
else
	echo " FAIL!"
	exit 1
fi

MYPID=$BASHPID

cat /etc/hosts | grep -vE "traffic|votan|snm|head" | grep "$1" | awk '{print $2}' | grep -v "^$" > /tmp/reload_tmp.$MYPID.list

declare -i i=0

# Для каждого из из списка качаем обновления, 15 сек на индексацию,
# переключаем эфир, позволяем визуально сравнить вывод mpc до и после.
query='getmusic | grep -v "random: off" | grep -v "Updating DB" ; sleep 15 ; /opt/market.php ; mpc | grep playing'
if [[ $parallel = 1  ]]
then
	for k in `cat /tmp/reload_tmp.$MYPID.list`
	do
		echo "Start parallel update $k."
		ssh $k $query 1>&2 &
	done
else
	for k in `cat /tmp/reload_tmp.$MYPID.list`
	do
		echo ""
		echo "Update $k:"
		if [[ `ssh $k $query 1>&2 && echo "ok"` ]]
		then true
		else
			faildserv[$i]=$k
			i=i+1
		fi
	done
fi

if [ -n "${faildserv[0]}" ]
then
	echo ""
	echo "Attention! Failed servers:"
fi
for j in ${faildserv[@]}
	do
	echo $j
done

rm /tmp/reload_tmp.$MYPID.list

exit 0
