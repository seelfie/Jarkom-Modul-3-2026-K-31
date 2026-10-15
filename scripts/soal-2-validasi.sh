#!/bin/sh
echo "===== $(hostname) ====="
echo "--- IP eth0 ---"
ip -4 a show eth0 | grep inet
echo "--- INTERFACES ---"
grep INTERFACES /etc/default/isc-dhcp-server
echo "--- Validasi config ---"
dhcpd -t -cf /etc/dhcp/dhcpd.conf && echo "Sintaks OK"

service isc-dhcp-server restart
sleep 2
service isc-dhcp-server status
echo "--- Proses dan port ---"
ps aux | grep [d]hcpd
ss -ulnp | grep :67
echo "--- Isi dhcpd.conf ---"
cat /etc/dhcp/dhcpd.conf