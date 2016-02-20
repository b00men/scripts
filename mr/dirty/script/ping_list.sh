#!/bin/bash 

cat /etc/hosts | grep -vE "traffic|votan|snm|head" | grep "$1" | awk '{print $2}' | grep -v "^$" > reload_tmp.list

declare -i i=0

for k in `cat reload_tmp.list`
do
	#echo ""
	echo -n "Ping $k: "
	ping -c 1 -q $k | grep received | awk '{print $4}'
	#then true
	#else
	#	faildserv[$i]=$k
	#	i=i+1
	#fi
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
