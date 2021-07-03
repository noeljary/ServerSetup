#!/bin/bash

# Install libpam Module for Google Auth
apt-get install --assume-yes libpam-google-authenticator

# Enable libpam Module
sed -i 's/@include common-auth/#@include common-auth/' /etc/pam.d/sshd
echo "auth required pam_google_authenticator.so" >> /etc/pam.d/sshd

# Update SSHD Config
IPADDR=$(ifconfig | grep eth0 -A1 | tail -n1 | awk '{print $2}')
sed -i 's/PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config
sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
sed -i 's/ChallengeResponseAuthentication no/ChallengeResponseAuthentication yes/' /etc/ssh/sshd_config
echo -e "Match LocalAddress "${IPADDR}"\n\tAuthenticationMethods publickey,keyboard-interactive" >> /etc/ssh/sshd_config

# Restart SSH Daemon
service ssh restart
