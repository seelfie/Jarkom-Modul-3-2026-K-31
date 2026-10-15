#!/bin/sh

echo "nameserver 192.168.122.1" > /etc/resolv.conf

apt update
apt install -y iptables

sysctl -w net.ipv4.ip_forward=1

iptables -t nat -C POSTROUTING -o eth0 -j MASQUERADE 2>/dev/null || \
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE

for i in eth1 eth2 eth3 eth4; do
  iptables -C FORWARD -i $i -o eth0 -j ACCEPT 2>/dev/null || \
  iptables -A FORWARD -i $i -o eth0 -j ACCEPT
done

iptables -C FORWARD -i eth0 -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT 2>/dev/null || \
iptables -A FORWARD -i eth0 -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT