#!/bin/sh
for f in /etc/dhcp/conf.d/net2.conf; do
 
  sed -i '/option domain-name-servers/d;/option domain-search/d;/option domain-name /d' $f

  sed -i '/option routers/a\    option domain-name-servers 10.79.1.2, 10.79.1.3;\n    option domain-search "K31.com";\n    option domain-name "K31.com";' $f
done

echo "--- validasi ---"
dhcpd -t -cf /etc/dhcp/dhcpd.conf && echo "Sintaks OK"

echo "--- opsi jaringan per subnet ---"
grep -nE "subnet|routers|broadcast|domain" /etc/dhcp/conf.d/net2.conf /etc/dhcp/conf.d/net3.conf

service isc-dhcp-server restart
sleep 2
service isc-dhcp-server status