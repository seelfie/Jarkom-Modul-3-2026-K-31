#!/bin/sh
MAC_KUGISAKI="02:42:01:49:4c:00"
IP_KUGISAKI="10.79.3.99"

cat > /etc/dhcp/conf.d/hosts.conf <<CONF
host kugisaki {
    hardware ethernet ${MAC_KUGISAKI};
    fixed-address ${IP_KUGISAKI};
}
CONF

grep -q 'conf.d/hosts.conf' /etc/dhcp/dhcpd.conf || \
echo 'include "/etc/dhcp/conf.d/hosts.conf";' >> /etc/dhcp/dhcpd.conf

echo "--- validasi ---"
dhcpd -t -cf /etc/dhcp/dhcpd.conf && echo "Sintaks OK"

echo "--- cek di luar pool ---"
grep -n "range" /etc/dhcp/conf.d/net3.conf

service isc-dhcp-server restart
sleep 2
service isc-dhcp-server status