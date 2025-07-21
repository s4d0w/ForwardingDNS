#!/bin/bash
#########################################
# chmod +x Forwarding-DNS-Setup.sh
# ./Forwarding-DNS-Setup.sh
#########################################

set -e

yum -q -y bind bind-utils

cp -p named.conf /etc/named.conf
cp -p named.rfc1912.zones /etc/named.rfc1912.zones

cp -p example.zone /var/named/example.zone
cp -p example.rev /var/named/example.rev
cp -p test.zone /var/named/test.zone

systemctl restart named
systemctl enable named

firwall-cmd --permanent --add-service=dns
fireall-cmd --reload

nmcli connection modify eth0 \
  ipv4.dns 192.168.10.20 \
  +ipv4.dns 8.8.8.8 \
  ipv4.dns-search example.com
nmcli connection up eth0

