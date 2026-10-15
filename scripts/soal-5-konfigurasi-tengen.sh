#!/bin/sh
MAC_INO="02:42:97:71:9c:00"
MAC_KUSAKABE="02:42:b9:bd:e6:00"
MAC_MIWA="02:42:eb:4b:9e:00"

cat > /etc/dhcp/conf.d/net3.conf <<CONF
# Class berdasarkan MAC address (Network 3)
class "short-lease" {
    match hardware;
}
subclass "short-lease" 1:${MAC_INO};
subclass "short-lease" 1:${MAC_KUSAKABE};

class "long-lease" {
    match hardware;
}
subclass "long-lease" 1:${MAC_MIWA};

# Network 3
subnet 10.79.3.0 netmask 255.255.255.0 {
    option routers 10.79.3.1;
    option broadcast-address 10.79.3.255;
    option domain-name-servers 10.79.1.2, 10.79.1.3;
    option domain-search "K31.com";

    # Short lease: ino, kusakabe (30 menit)
    pool {
        allow members of "short-lease";
        range 10.79.3.10 10.79.3.89;
        default-lease-time 1800;
        max-lease-time 1800;
    }

    # Long lease: miwa (12 jam)
    pool {
        allow members of "long-lease";
        range 10.79.3.100 10.79.3.199;
        default-lease-time 43200;
        max-lease-time 43200;
    }
}
CONF

dhcpd -t -cf /etc/dhcp/dhcpd.conf && echo "Sintaks OK"

service isc-dhcp-server stop
: > /var/lib/dhcp/dhcpd.leases
service isc-dhcp-server start
service isc-dhcp-server status
