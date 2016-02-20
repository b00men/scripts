#!/bin/bash 

if [[ `whoami` != "root" ]]
then
	echo You need to be root to perform this command. 
	exit 1
fi

cat /etc/hosts | grep -vE "traffic|votan|snm|head" | grep "$1" | awk '{print $2}' | grep -v "^$" > reload_tmp.list

declare -i i=0
declare -i y=0

query="cat /usr/bin/getmusic | grep getmusic.py > /dev/null && true || ( hostname && echo DID NOT HAVE GETMUSIC.PY )"

for k in `cat reload_tmp.list`
do
	#echo ""
	#echo "Unholded $k:"
	if [[ `ssh $k "$query" 1>&2 && echo "ok"` ]]
	then
		bugserv[$y]=$k
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
echo "Server with bug:"
for z in ${bugserv[@]}
        do
	echo $z
done


exit 0
