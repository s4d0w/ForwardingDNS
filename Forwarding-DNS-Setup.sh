#!/bin/bash
#########################################
# chmod +x Forwarding-DNS-Setup.sh
# ./Forwarding-DNS-Setup.sh
#########################################

set -e

echo "[  OK  ] DNS 서버 설정 시작"

echo "[1] BIND 및 유틸 설치"
yum -q -y install bind bind-utils

echo "[2] 설정 파일 복사"
cp -p named.conf /etc/named.conf
cp -p named.rfc1912.zones /etc/named.rfc1912.zones

echo "[3] Zone 파일 복사"
cp -p example.zone /var/named/example.zone
cp -p example.rev /var/named/example.rev
cp -p test.zone /var/named/test.zone

echo "[4] named 재시작 및 활성화"
systemctl restart named
systemctl enable named

echo "[5] 방화벽 DNS 허용"
firewall-cmd --permanent --add-service=dns
firewall-cmd --reload

echo "[6] DNS 설정 변경 (NetworkManager)"
nmcli connection modify eth0 \
  ipv4.dns 192.168.10.20 \
  +ipv4.dns 8.8.8.8 \
  ipv4.dns-search example.com
nmcli connection up eth0

echo "[  OK  ] DNS 서버 설정 완료!"
