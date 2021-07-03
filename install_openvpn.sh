#!/bin/bash

# Enable IPv4 Packet Forwarding
sed -i 's/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/' /etc/sysctl.conf
sysctl -p

# Install OpenVPN Packages
apt-get install -y openvpn easy-rsa

# Generate Server Certificate and Key
cp -r /usr/share/easy-rsa /etc/openvpn/
cd /etc/openvpn/easy-rsa
mv vars.example vars
vi vars
./easyrsa init-pki
./easyrsa build-ca nopass
./easyrsa gen-req uk01-server nopass
./easyrsa sign-req server uk01-server
./easyrsa gen-dh
openvpn --genkey --secret ta.key
cp ta.key /etc/openvpn/
cp pki/ca.crt /etc/openvpn/
cp pki/private/uk01-server.key /etc/openvpn/server.key
cp pki/issued/uk01-server.crt /etc/openvpn/server.crt
cp pki/dh.pem /etc/openvpn/

# Generate Client Certificate and Key
./easyrsa gen-req testclient nopass
./easyrsa sign-req client testclient
cp pki/ca.crt /etc/openvpn/client/
cp pki/issued/testclient.crt /etc/openvpn/client/
cp pki/private/testclient.key /etc/openvpn/client/

# Configure VPN Server
cp ~/server-setup/conf/vpn.conf /etc/openvpn/server.conf
cp ~/server-setup/conf/client.ovpn /etc/openvpn/client/client.ovpn
systemctl start openvpn@server
systemctl status openvpn@server