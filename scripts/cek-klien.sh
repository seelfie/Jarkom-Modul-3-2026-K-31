#!/bin/sh
echo "===== $(hostname) ====="
echo "MAC : $(ip link show eth0 | awk '/link\/ether/ {print $2}')"
echo "--- IP eth0 ---"
ip -4 a show eth0 | grep inet
echo "--- Routing ---"
ip route
echo "--- resolv.conf ---"
cat /etc/resolv.conf