#!/bin/bash
# Add virtual servers (ssh,NX,tinc->snm)
if [[ `whoami` != "root" ]]
then
	echo You need to be root to perform this command. 
	exit 1
fi

SNM=192.168.0.101
WAN=31.211.70.3
SSH=2200
NX=4100
# ssh to snm
iptables -t nat -A PREROUTING --dst $WAN -p tcp --dport $SSH -j DNAT --to-destination $SNM:22
iptables -I FORWARD 1 -i eth0 -o eth1 -d $SNM -p tcp -m tcp --dport 22 -j ACCEPT

# NX to snm
iptables -t nat -A PREROUTING --dst $WAN -p tcp --dport $NX -j DNAT --to-destination $SNM:4000
iptables -I FORWARD 1 -i eth0 -o eth1 -d $SNM -p tcp -m tcp --dport 4000 -j ACCEPT
# opt 4 virt
#iptables -t nat -A PREROUTING --dst 31.211.70.3 -p tcp --dport 4101 -j DNAT --to-destination 192.168.0.101:4001
#iptables -I FORWARD 1 -i eth0 -o eth1 -d 192.168.0.101 -p tcp -m tcp --dport 4001 -j ACCEPT

# tinc to snm
iptables -t nat -A PREROUTING --dst $WAN -p tcp --dport 655 -j DNAT --to-destination $SNM
iptables -t nat -A PREROUTING --dst $WAN -p udp --dport 655 -j DNAT --to-destination $SNM
iptables -I FORWARD 1 -i eth0 -o eth1 -d $SNM -p tcp -m tcp --dport 655 -j ACCEPT
iptables -I FORWARD 1 -i eth0 -o eth1 -d $SNM -p udp --dport 655 -j ACCEPT
