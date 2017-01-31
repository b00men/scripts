#!/bin/sh
if [ $# -gt 0 ]; then
	cat $1 | egrep -v -e "https?://" -e "^$" | sed -e "s/\[[0-9]*\]//g" -e "s/\*\*/*/g" -e "s/\[//g" -e "s/\]//g"
else
	egrep -v -e "https?://" -e "^$" | sed -e "s/\[[0-9]*\]//g" -e "s/\*\*/*/g" -e "s/\[//g" -e "s/\]//g"
fi
