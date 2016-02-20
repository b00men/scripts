#!/bin/bash
EXT_IP="31.24.28.60" # Он всё равно чаще всего один и тот же.
INT_IP="192.168.0.1" # См. выше.
EXT_IF=tomgate # Внешний и внутренний интерфейсы.
INT_IF=eth1 # Для шлюза они вряд ли изменятся, поэтому можно прописать вручную.
FAKE_PORT=$1  # Вначале передаём скрипту "неправильный" порт на внешнем интерфейсе,
LAN_IP=$2     # затем - локальный адрес сервера
SRV_PORT=$3   # и в конце - реальный порт для подключения к серверу

# Здесь опять надо сделать проверку ввода данных, потому что операции всё ещё серьёзные.

iptables -t nat -A PREROUTING -d $EXT_IP -p tcp -m tcp --dport $FAKE_PORT -j DNAT --to-destination $LAN_IP:$SRV_PORT
iptables -t nat -A POSTROUTING -d $LAN_IP -p tcp -m tcp --dport $SRV_PORT -j SNAT --to-source $INT_IP
iptables -t nat -A OUTPUT -d $EXT_IP -p tcp -m tcp --dport $SRV_PORT -j DNAT --to-destination $LAN_IP
iptables -I FORWARD 1 -i $EXT_IF -o $INT_IF -d $LAN_IP -p tcp -m tcp --dport $SRV_PORT -j ACCEPT
