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

query="cp -f '/work/\`PL01.m3u' '/work/\`holdPL01.m3u'; \
	cp -f '/work/\`PL02.m3u' '/work/\`holdPL02.m3u'; \
	cp -f '/work/\`PL03.m3u' '/work/\`holdPL03.m3u'; \
	cp -f '/work/\`PL04.m3u' '/work/\`holdPL04.m3u'; \
	cp -f '/work/\`PL05.m3u' '/work/\`holdPL05.m3u'; \
	cp -f '/work/\`PL06.m3u' '/work/\`holdPL06.m3u'; \
	cp -f '/work/\`PL07.m3u' '/work/\`holdPL07.m3u'; \
	cp -f /opt/market.php /opt/market.php.bak; \
	cp -f /usr/bin/playmusic /opt/playmusic.bak; \
	cat /opt/market.php | sed -e s/PL0/holdPL0/g > /opt/market.php.hold; \
	cat /usr/bin/playmusic | sed -e s/PL0/holdPL0/g > /opt/playmusic.hold; \
	cp -f /opt/market.php.hold /opt/market.php; \
	cp -f /opt/playmusic.hold /usr/bin/playmusic"

for k in `cat reload_tmp.list`
do
	echo ""
	echo "Holded $k:"
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
