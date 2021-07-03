#!/bin/bash

# Store current DIR
CDIR=$(pwd)

# Move into easy-rsa directorry
cd /etc/openvpn/easy-rsa

# Set NEW_ACCT variable with command line input
NEW_ACCT=$1

# Generate certificates
./easyrsa gen-req ${NEW_ACCT} nopass
./easyrsa sign-req client ${NEW_ACCT}

# Move certificates to correct location
cp pki/issued/${NEW_ACCT}.crt /etc/openvpn/client/
cp pki/private/${NEW_ACCT}.key /etc/openvpn/client/

# Generate custom client.ovpn
cd ../client
cp template.ovpn client.ovpn
sed -i 's/client.crt/'${NEW_ACCT}'.crt/' client.ovpn
sed -i 's/client.key/'${NEW_ACCT}'.key/' client.ovpn

# Create connection tar bundle
tar zcvf ${NEW_ACCT}.tar.gz ../ta.key ca.crt client.ovpn ${NEW_ACCT}.crt ${NEW_ACCT}.key

# Remove custom connection file
rm client.ovpn

# Move tar bundle to run dir
mv ${NEW_ACCT}.tar.gz ${CDIR}/

# DONE
