#!/bin/sh

# Для CentOS.
# На debian "arp: not found".

# Грубо проверяет интервал локальных адресов по arp таблице и показывает их MAC
# Форсирует добавление в таблицу пингом (ответ необязателен)

for i in `seq 1 254` 
do 
ping -c 1 -w 400 -l 1 192.168.0.$i | arp -a 192.168.0.$i | grep ether >> /tmp/ping_arp_file.txt
done
cat /tmp/ping_arp_file.txt
rm /tmp/ping_arp_file.txt

