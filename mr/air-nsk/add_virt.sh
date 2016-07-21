#!/bin/bash

# Быстрое создание виртуальной машины по образу cs.
# Скрипт небесопасен, рекомендуется чтение или переписать.
# Создает снапшот раздела, конфигурирует xml новой машины,
# добавляет машину в /etc/hosts, на машине изменяется ip и mac.
#
# Прочая конфигурация виртуальной машины не происходит!
# Файл virt_config.sh пока не используется.

# str-orig is 5G
VMSIZE=1G

if [[ `whoami` != "root" ]]
then
	echo You need to be root to perform this command. 
	exit 1
fi

lvs vg_vm -o lv_name,origin,lv_attr,lv_size,data_percent
echo "  --"
vgs vg_vm
echo
read -p "Continue? [y/N]: " ANSWER
[ "$ANSWER" != "y" ] && [ "$ANSWER" != "Y" ] && exit 0

echo
read -p "Name of new VM [testlink]: " VMNAME
[ "$VMNAME" = "" ] && VMNAME="testlink"

echo -n "Create lv_$VMNAME... "
lvcreate -s -n lv_$VMNAME -L $VMSIZE /dev/vg_vm/lv_str || exit 1

echo "Configuration xml of $VMNAME..."
cp /root/xml/str_template.xml /root/xml/$VMNAME.xml

declare -i COUNT=4001
declare -i IPADDR=5
UNIQ=`printf "%04i" $((COUNT))`
ADDMAC=`echo $UNIQ | sed 's/^\(..\)\(..\)/\1:\2/'`
while true
do
	cat /root/xml/* | grep "$UNIQ\|$ADDMAC" > /dev/null || break
	COUNT=$COUNT+1
	UNIQ=`printf "%04i" $((COUNT))`
	ADDMAC=`echo $UNIQ | sed 's/^\(..\)\(..\)/\1:\2/'`
done

while true
do
	cat /etc/hosts | grep "192.168.123.$IPADDR" > /dev/null || break
	[ "$IPADDR" = "254" ] && exit 1
	IPADDR=$IPADDR+1
done

sed -i -e "s/NAME_OF_VM/$VMNAME/g" -e "s/UNIQ_OF_VM/$UNIQ/" -e "s/ADDMAC_OF_VM/$ADDMAC/" /root/xml/$VMNAME.xml

virsh define /root/xml/$VMNAME.xml
ln -s /etc/libvirt/qemu/$VMNAME.xml /etc/libvirt/qemu/autostart/

echo "Configuration network of $VMNAME..."
guestfish -i -d $VMNAME download /etc/network/interfaces /tmp/vm.net
sed -i "s/192.168.123.7/192.168.123.$IPADDR/" /tmp/vm.net
guestfish -i -d $VMNAME upload /tmp/vm.net /etc/network/interfaces
virsh start $VMNAME
echo "192.168.123.$IPADDR $VMNAME" >> /etc/hosts

echo "Waiting for starting $VMNAME..."
sleep 20

CMDUPDATE="hostname $VMNAME; echo $VMNAME > /etc/hostname; sed -i s/testtest/redexpress/g /etc/mpd.conf ; service mpd restart ; getmusic; sleep 15 ; market; mpc"
su b00men -c "`echo ssh root@$VMNAME \'$CMDUPDATE\'`"
echo "VM $VMNAME ready"
