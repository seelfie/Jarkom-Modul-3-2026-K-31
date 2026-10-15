#!/bin/sh
echo "===== $(hostname) ====="
echo "MAC : $(ip link show eth0 | awk '/link\/ether/ {print $2}')"

ip addr flush dev eth0
udhcpc -i eth0 -n -q

echo "--- IP eth0 ---"
ip -4 a show eth0 | grep inet
echo "--- Route ---"
ip route
echo "--- DNS ---"
cat /etc/resolv.conf
GW=$(ip route | awk '/^default/ {print $3}')
if [ -n "$GW" ]; then
  echo "--- Ping gateway ($GW) ---"
  ping -c 3 $GW
else
  echo "Tidak ada default route, lease gagal"
fi