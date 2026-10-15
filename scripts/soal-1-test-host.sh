#!/bin/sh
echo "nameserver 192.168.122.1" > /etc/resolv.conf

GW=$(ip route | awk '/^default/ {print $3}')

echo "===== $(hostname) ====="
echo "--- IP eth0 ---"
ip -4 a show eth0 | grep inet
echo "--- Routing ---"
ip route
echo "--- resolv.conf ---"
cat /etc/resolv.conf

if [ -z "$GW" ]; then
  echo "!! Tidak ada default route, cek konfigurasi IP/gateway"
  exit 1
fi

echo "--- Ping gateway ($GW) ---"
ping -c 3 $GW
echo "--- Ping internet (tes routing + NAT) ---"
ping -c 3 8.8.8.8
echo "--- Ping domain (tes DNS) ---"
ping -c 3 deb.debian.org