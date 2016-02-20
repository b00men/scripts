#!/bin/bash

# Обновляет эфир перечисленных объектов на старом трафике.
# Запускается после выгрузки.
# Использование ./reload.sh host1 host2 host3 ...

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

declare -i i=0

# Для каждого из перечисленных качаем обновления, 15 сек на индексацию,
# переключаем эфир, позволяем визуально сравнить вывод mpc до и после.
query='getmusic | grep -v "random: off" | grep -v "Updating DB" ; sleep 15 ; /opt/market.php ; mpc | grep playing'
until [ -z "$1" ]
do
	echo ""
	echo "Update $1:"
	if [[ `ssh $1 $query 1>&2 && echo "ok"` ]]
	then true
	else
		faildserv[$i]=$1
		i=i+1
	fi
	shift
done

if [ -n "${faildserv[0]}" ]
then
	echo ""
	echo "Attention! Failed servers:"
fi
for j in ${faildserv[@]}
	do
	echo $j
done

exit 0
