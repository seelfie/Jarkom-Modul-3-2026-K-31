#!/bin/sh
apt update
apt install -y isc-dhcp-server

sed -i 's/^INTERFACESv4=.*/INTERFACESv4="eth0"/' /etc/default/isc-dhcp-server
mkdir -p /etc/dhcp/conf.d

cat > /etc/dhcp/dhcpd.conf <<CONF
authoritative;
default-lease-time 600;
max-lease-time 7200;

include "/etc/dhcp/conf.d/classes.conf";
include "/etc/dhcp/conf.d/net4.conf";
include "/etc/dhcp/conf.d/net2.conf";
include "/etc/dhcp/conf.d/net3.conf";
CONF

touch /etc/dhcp/conf.d/classes.conf

cat > /etc/dhcp/conf.d/net4.conf <<CONF
# Network 4 - subnet lokal
subnet 10.79.4.0 netmask 255.255.255.0 {
    option routers 10.79.4.1;
}
CONF

cat > /etc/dhcp/conf.d/net2.conf <<CONF
# Network 2 - scope DHCP
subnet 10.79.2.0 netmask 255.255.255.0 {
    range 10.79.2.10 10.79.2.200;
    option routers 10.79.2.1;
    option broadcast-address 10.79.2.255;
    option domain-name-servers 192.168.122.1;
}
CONF

cat > /etc/dhcp/conf.d/net3.conf <<CONF
# Network 3 - scope DHCP
subnet 10.79.3.0 netmask 255.255.255.0 {
    range 10.79.3.10 10.79.3.200;
    option routers 10.79.3.1;
    option broadcast-address 10.79.3.255;
    option domain-name-servers 192.168.122.1;
}
CONF

dhcpd -t -cf /etc/dhcp/dhcpd.conf && echo "done"
service isc-dhcp-server restart