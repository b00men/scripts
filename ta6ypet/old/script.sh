#!/bin/sh
#
# Script Version 7.2.18
#
# This script has been made for send information about new ip related with it dns record.
#    Changelog:    01.05.2012 - changed mechanism of generating domain name from mac to system title
#                            using nslookup instead dig for reduce disk usage space
#                10.05.2012 - added possibility to work with dns servers based on linux or windows OS.
#
# Made by Evgheni Antropov - aidjek@gmail.com

NSUPDATE=/dnstools/nsupdate
NSLOOKUP=/usr/bin/nslookup
IFACE="$1"
DOMAIN=book.ta6ypet.ru
TTL=3600
DNSSERVER="$2"
#HOSTNAME=$(ifconfig eth0 | grep HWaddr | awk '{print $NF}' | sed -e 's/://g').$DOMAIN
HOSTNAME=$(cat /dev/urandom | tr -d -c 'a-zA-Z0-9' | fold -w 10 | head -1).$DOMAIN

ZONE=$(echo $DOMAIN)

if [[ -n "$1" && -n "$2" ]]; then
    old_ip_address=$($NSLOOKUP $HOSTNAME $DNSSERVER | grep -A1 Name | awk '{print $NF}' | sed 1d)
    new_ip_address=$(ifconfig $IFACE | grep "inet addr:" | awk '{print $2}' |  cut -d\: -f2)
    if [ "$new_ip_address" != "$old_ip_address" ]; then
# if DNS server based on linux
        if [ "$3" = "linux" ]; then
        KEYFILE=$(ls -1 /dnstools/K${DOMAIN}*.private)
            if [ ! -e $KEYFILE ]; then
                cd /dnstools
                /dnstools/dnssec-keygen -b 512 -a HMAC-MD5 -v 2 -n HOST $DOMAIN
                echo "Please add on BIND server correct Key Value, taken from $KEYFILE"
                exit 1
            fi
            NSUPDATE="$NSUPDATE -k $KEYFILE"
        fi
# by default DNS server based on windows
            $NSUPDATE -v << EOF
            server $DNSSERVER
            zone $ZONE
            update delete $HOSTNAME A
            update add $HOSTNAME $TTL A $new_ip_address
            send
EOF
    fi
else
    echo "Please use \"/dnstools/ddnsupdate %Interface% %DNS_server_IP%\""
fi
