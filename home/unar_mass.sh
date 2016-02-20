#!/bin/bash

# Shell for mass unar

if [ $# -lt 2 ]
then
	echo "Use as"
	echo "unar_mass DIR FILE1 [FILE2] ..."
fi

DIR="$1"
shift
until [ -z "$1" ]
do
	unar -f "$1" -o $DIR
	shift
done
