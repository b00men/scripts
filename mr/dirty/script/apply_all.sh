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

cat /etc/hosts | grep -vE "traffic|votan|snm|head" | awk '{print $2}' | grep -v "^$" > all.list

#declare -i i=0

for i in `cat all.list`
do
ssh $i 'hostname ; mpc | grep playing; /opt/market.php ; mpc | grep playing' &
done

#declare -i i=0

#until [ -z "$1" ]
#do
#	echo ""
#	echo "Update $1:"
#	if [[ `ssh $1 'getmusic | grep -v "random: off" | grep -v "Updating DB" ; sleep 15 ; /opt/market.php ; mpc | grep playing' 1>&2 && echo "ok"` ]]
#	then true
#	else
#		faildserv[$i]=$1
#		i=i+1
#	fi
#	shift
#done

#if [ -n "${faildserv[0]}" ]
#then
#	echo ""
#	echo "Attention! Failed servers:"
#fi
#for j in ${faildserv[@]}
#	do
#	echo $j
done

exit 0
