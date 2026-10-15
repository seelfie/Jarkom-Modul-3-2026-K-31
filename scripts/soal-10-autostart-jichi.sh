#!/bin/sh
if [ "$(ps -p 1 -o comm=)" = "systemd" ]; then
  systemctl enable isc-dhcp-relay
fi

grep -q 'service isc-dhcp-relay start' /etc/network/interfaces || \
sed -i '/^    address 10.79.4.1/a\    up service isc-dhcp-relay start' /etc/network/interfaces

echo "--- interfaces jichi ---"
cat /etc/network/interfaces
echo "--- konfigurasi relay ---"
cat /etc/default/isc-dhcp-relay