#!/bin/sh
echo "===== $(hostname) ====="
echo "--- IP interface ---"
ip -4 a | grep -E "^[0-9]+:|inet "
echo "--- Routing ---"
ip route
echo "--- IP forwarding ---"
cat /proc/sys/net/ipv4/ip_forward
echo "--- Tes akses eksternal ---"
ping -c 2 8.8.8.8
ping -c 2 deb.debian.org
echo "--- Rule NAT  ---"
iptables -t nat -L POSTROUTING -n -v
echo "--- Rule FORWARD ---"
iptables -L FORWARD -n -v