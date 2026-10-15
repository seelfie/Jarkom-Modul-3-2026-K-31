#!/bin/sh
if [ "$(ps -p 1 -o comm=)" = "systemd" ]; then
  systemctl enable isc-dhcp-server
fi

grep -q 'service isc-dhcp-server start' /etc/network/interfaces || \
sed -i '/^    gateway 10.79.4.1/a\    up service isc-dhcp-server start' /etc/network/interfaces

echo "--- interfaces tengen ---"
cat /etc/network/interfaces