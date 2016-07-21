#!/bin/bash
# Add virtual servers (ssh,NX,tinc->snm)
if [[ `whoami` != "root" ]]
then
	echo You need to be root to perform this command. 
	exit 1
fi

SERV=192.168.0.3
WAN=31.211.70.3

# 80&8080 to 192.168.0.5
#iptables -t nat -A PREROUTING --dst $WAN -p tcp --dport 60580 -j DNAT --to-destination $SERV:80
#iptables -I FORWARD 1 -i eth0 -o eth1 -d $SERV -p tcp -m tcp --dport 80 -j ACCEPT
iptables -t nat -A PREROUTING --dst $WAN -p tcp --dport 60321 -j DNAT --to-destination $SERV:21
iptables -I FORWARD 1 -i eth0 -o eth1 -d $SERV -p tcp -m tcp --dport 21 -j ACCEPT
