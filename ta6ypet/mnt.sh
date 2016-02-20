#!/bin/bash

if [[ `whoami` != "root" ]]
then
	echo You need to be root to perform this command.
	exit 1
fi

mount -U 5106d390-4d38-4600-947f-56cf50d6581a /mnt/oldroot
mount -U c5a7be26-2d1f-497f-be72-ddf93860478b /mnt/backups
mount -U c026d4f6-16ef-4f9f-a3fd-ea3bf651846e /mnt/bacup_root_1
mount -U e8286a58-e03d-4d92-8a6e-c2ae4b69b0a0 /mnt/bacup_root_2
mount -U b93d3df3-4f5a-4a9f-9226-e18362d7c561 /mnt/nowroot
