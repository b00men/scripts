#!/bin/bash

# Убедитесь, что при подключении к серверу по "sudo ssh host"
# не возникает ошибки (несоотвтетствие отпечатка)
# и не возникает вопроса "yes/no"

# Скрипт автоматической подготовки серверов,
# по типу dexp неттопов сразу после установки debian.
# Очень сырой, только зачатки.
# Писался для старого трафика. Актуаьно переписать под новый.

if [[ `whoami` != "root" ]]
then
	echo You need to be root to perform this command. 
	exit 1
fi

SERV_HOST="192.168.0.202"
SERV_USER="backdoor"
SERV_PASS="rapeme"
SERV_RPASS="vepsrfvfhrtn"

# Внешним скриптом включаем вход по паролю,
# добавляем публичный ключ, перезагружаем sshd
expect sshrooton.exp $SERV_HOST $SERV_USER $SERV_PASS $SERV_RPASS

sleep 5


scp new_tr.sh $SERV_HOST:~/
ssh $SERV_HOST './new_tr.sh'
# Установка старого трафика. Актуально переписать эту часть
# и client_old_dexp_install.sh под новый трафик.
#ssh $SERV_HOST 'apt-get update && apt-get install -y rsync'
#rsync -avr --progress --exclude "- authorized_keys" /home/server/chroot/ $SERV_HOST:/

#scp client_old_dexp_install.sh $SERV_HOST:~/
#ssh $SERV_HOST 'chmod +x client_old_dexp_install.sh && ./client_old_dexp_install.sh'
