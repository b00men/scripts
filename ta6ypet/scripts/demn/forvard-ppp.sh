#!/bin/sh
echo 1 > /proc/sys/net/ipv4/ip_forward
echo 1 > /proc/sys/net/ipv4/ip_dynaddr
iptables -P FORWARD ACCEPT
modprobe iptable_nat
modprobe ip_conntrack_ftp
modprobe ip_nat_ftp
iptables –table nat –append POSTROUTING –out-interface eth0
echo vpn firewall loaded OK.
