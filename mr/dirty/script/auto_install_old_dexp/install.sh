#!/bin/bash

if [[ `whoami` != "root" ]]
then
	echo You need to be root to perform this command. 
	exit 1
fi

SERV_HOST="192.168.0.220"
SERV_USER="backdoor"
SERV_PASS="rapeme"
SERV_RPASS="djc[jl"

# Внешним скриптом включаем вход по паролю,
# добавляем публичный ключ, перезагружаем sshd
expect sshrooton.exp $SERV_HOST $SERV_USER $SERV_PASS $SERV_RPASS

sleep 5

ssh $SERV_HOST 'apt-get update && apt-get install -y rsync'
rsync -avr --progress --exclude "- authorized_keys" /home/server/chroot/ $SERV_HOST:/

scp client_old_dexp_install.sh $SERV_HOST:~/

ssh $SERV_HOST 'chmod +x client_old_dexp_install.sh && ./client_old_dexp_install.sh'
