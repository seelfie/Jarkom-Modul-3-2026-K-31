#!/bin/sh
MAC_ITADORI="02:42:84:8e:7f:00"
MAC_FUSHIGURO="02:42:b3:70:a5:00"
MAC_ZENIN="f2:dd:ec:51:c9:cb"
MAC_OKKOTSU="02:42:c1:aa:65:00"

cat > /etc/dhcp/conf.d/classes.conf <<CONF
class "pool1" {
    match hardware;
}
subclass "pool1" 1:${MAC_ITADORI};
subclass "pool1" 1:${MAC_FUSHIGURO};

class "pool2" {
    match hardware;
}
subclass "pool2" 1:${MAC_ZENIN};
subclass "pool2" 1:${MAC_OKKOTSU};
CONF

cat > /etc/dhcp/conf.d/net2.conf <<CONF
subnet 10.79.2.0 netmask 255.255.255.0 {
    option routers 10.79.2.1;
    option broadcast-address 10.79.2.255;
    option domain-name-servers 192.168.122.1;

    # Pool 1: itadori, fushiguro
    pool {
        allow members of "pool1";
        range 10.79.2.10 10.79.2.35;
    }

    # Pool 2: zenin, okkotsu
    pool {
        allow members of "pool2";
        range 10.79.2.70 10.79.2.95;
    }
}
CONF

dhcpd -t -cf /etc/dhcp/dhcpd.conf && echo "Sintaks OK"

service isc-dhcp-server stop
: > /var/lib/dhcp/dhcpd.leases
service isc-dhcp-server start
service isc-dhcp-server status