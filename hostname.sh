#!/bin/bash

if [ $# -gt 0 ] && [ $1 != '' ]
then
	# Ensure dbus is installed
	apt-get install --assume-yes dbus
	
	# Set Hostname
	export NEWHOST=$1
	sed -i 's/'$(hostname)'/'${NEWHOST}'/' /etc/hosts
	hostnamectl set-hostname ${NEWHOST}
else 
	echo "No Hostname Provided"
	exit -1
fi
