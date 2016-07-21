#!/bin/bash
# Add virtual servers (ssh,NX,tinc->snm)
if [[ `whoami` != "root" ]]
then
	echo You need to be root to perform this command. 
	exit 1
fi

iptables -A PREROUTING -s 192.168.0.0/24 ! -d 192.168.0.0/24 -p tcp -m tcp --dport 80 -j REDIRECT --to-ports 3128
