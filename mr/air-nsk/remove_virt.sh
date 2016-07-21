#!/bin/bash

# Удаление виртуальной машины, ее раздела, стирание ip из hosts.

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

echo -n "Stoping $VMNAME..."
su b00men -c "ssh -f root@$VMNAME poweroff"
while [ "`virsh list --all | awk '{print $2" "$3}' | grep "^$VMNAME выключен$"`" = "" ]
do
	echo -n "."
	sleep 3
done
echo " done"

guestfish -i -d $VMNAME download /etc/network/interfaces /tmp/vm.net || exit 1
IPADDR=`cat /tmp/vm.net | grep address | awk '{print $2}'`
virsh undefine $VMNAME || exit 1
lvremove /dev/vg_vm/lv_$VMNAME || exit 1
sed -i "/$IPADDR $VMNAME/d" /etc/hosts || exit 1

echo "Виртуальная машина $VMNAME успешно удалена"
