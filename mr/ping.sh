#!/bin/sh

# Для CentOS.
# На debian "arp: not found".

# Грубо проверяет интервал локальных адресов по arp таблице и показывает их MAC
# Форсирует добавление в таблицу пингом (ответ необязателен)
j=70
for i in `seq 1 254` 
do 
ping -c 1 -W 1 192.168.$j.$i | arp -a 192.168.$j.$i | grep ether
done

