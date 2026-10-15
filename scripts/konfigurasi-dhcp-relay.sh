#!/bin/sh

apt update
DEBIAN_FRONTEND=noninteractive apt install -y isc-dhcp-relay

cat > /etc/default/isc-dhcp-relay <<CONF
SERVERS="10.79.4.10"
INTERFACES="eth2 eth3 eth4"
OPTIONS=""
CONF

service isc-dhcp-relay restart
sleep 2
service isc-dhcp-relay status