#!/bin/bash 

if [[ `whoami` != "root" ]]
then
	echo You need to be root to perform this command. 
	exit 1
fi

cat /etc/hosts | grep -vE "traffic|votan|snm|head|^#" | grep "$1" | awk '{print $2}' | grep -v "^$" > reload_tmp.list

declare -i i=0


for k in `cat reload_tmp.list`
do
	echo ""
	echo "$k:"
	#ssh $k '' 
	ssh $k 'sed -i "s/^\(sed.*getmusic.*\)/#\1/" new_traffic_audio.sh'
	#ssh $k 'crontab -l | grep -v -e "^#" -e "music" -e "timesync"'
	#scp /home/b00men/script/new_traffic/new_traffic_audio.sh $k:~/
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
