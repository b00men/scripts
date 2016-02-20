#!/bin/bash

if [[ `whoami` != "root" ]]
then
	echo You need to be root to perform this command. 
	exit 1
fi

until [ -z "$1" ]
do
	scp /home/b00men/publicscripts/prepare00R4download.sh  $1:/tmp/
	ssh $1 '/tmp/./prepare00R4download.sh'
	rm -r -f /home/b00men/00R/$1
	mkdir -p /home/b00men/00R/$1
	scp $1:/tmp/00R4download/* /home/b00men/00R/$1/
	chmod 777 -R /home/b00men/00R/$1
	shift
done
