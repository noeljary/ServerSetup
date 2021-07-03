#!/bin/bash

# Install iptables-persistent
apt-get install --assume-yes iptables-persistent

# Load Firewall Rules
cp conf/rules.* /etc/iptables/
iptables-restore < /etc/iptables/rules.v4
iptables-restore < /etc/iptables/rules.v6

# Make Persistent
iptables-save > /etc/iptables/rules.v4
ip6tables-save > /etc/iptables/rules.v6