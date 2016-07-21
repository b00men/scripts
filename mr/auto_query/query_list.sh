#!/bin/bash 

# Исполняет $query на хостах из hosts, включающих
# в своем названии слово, переданное первым аргументом.
# Если аргумент не передан, то на всех, кроме traffic|votan|snm|head
# Например, ./query_list.sh gorozhanka исполнит запрос на всех горожанках.

query='cat /work/\`PL0* | grep "U-Nam - Bonus.mp3"'
quite=0

# quite
# 1 - прячет вывод query (если есть).
# 0 - прописывает каждую строку с сервером.

# Если query завершилось с успехом, то добавляет сервер в группу success.
# Если с ошибкой или хост недоступен (ошибка ssh), то в faildserv.
# В конце перечисляет содержимое групп.

# Требуем права рута для возможности подключения по ключу.
if [[ `whoami` != "root" ]]
then
	echo You need to be root to perform this command. 
	exit 1
fi

MYPID=$BASHPID

# Выделяем список интересуемых хостов.
cat /etc/hosts | grep -vE "traffic|votan|snm|head" | grep "$1" | awk '{print $2}' | grep -v "^$" > /tmp/query_tmp.$MYPID.list

declare -i i=0
declare -i y=0

if [[ $quite == 1 ]]
then
	query_full="$query >> /dev/null"
else
	query_full="$query"
fi

for k in `cat /tmp/query_tmp.$MYPID.list`
do
	if [[ $quite == 0 ]]
	then
		echo ""
		echo -n "$k: "
	fi
	if [[ `ssh -o ConnectTimeout=10 $k "$query_full" 1>&2 && echo "ok"` ]]
	then
		success[$y]=$k
		y=y+1
	else
		faildserv[$i]=$k
		i=i+1
	fi
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
echo ""
echo "Successful for:"
for z in ${success[@]}
        do
	echo $z
done 

rm /tmp/query_tmp.$MYPID.list

exit 0
