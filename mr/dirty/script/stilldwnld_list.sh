#!/bin/bash 

if [[ `whoami` != "root" ]]
then
	echo You need to be root to perform this command. 
	exit 1
fi

#echo -n "Mover in process..."
#if [ -z `/usr/bin/php /opt/mover/index.php 1>&2` ]
#then echo " OK"
#else
#	echo " FAIL!"
#	exit 1
#fi

cat /etc/hosts | grep -vE "traffic|votan|snm|head" | grep "$1" | awk '{print $2}' | grep -v "^$" > reload_tmp.list

declare -i i=0

query="ps ax | grep -v grep |grep getm"

for k in `cat reload_tmp.list`
do
	echo ""
	echo "Check $k:"
	if [[ `ssh $k "$query" 1>&2 && echo "ok"` ]]
	then true
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

exit 0
