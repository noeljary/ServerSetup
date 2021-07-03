#!/bin/bash

if [ $# -gt 0 ] && [ $1 != '' ]
then
	adduser $1
	usermod -aG sudo $1
else 
	echo "No User Provided"
	exit -1
fi
