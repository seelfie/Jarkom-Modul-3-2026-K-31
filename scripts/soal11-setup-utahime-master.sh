apt update
apt install bind9 bind9-utils dnsutils -y

cat > /etc/bind/named.conf.local << 'EOF'
zone "jujutsu.K31.com" {
        type master;
        file "/etc/bind/db.jujutsu.K31.com";
        allow-transfer { 10.79.1.3; };
        also-notify { 10.79.1.3; };
};
EOF

cat > /etc/bind/db.jujutsu.K31.com << 'EOF'
$TTL    86400
@       IN      SOA     utahime.jujutsu.K31.com. admin.jujutsu.K31.com. (
                2026101401
                3600
                1800
                604800
                86400
)

@       IN      NS      utahime.jujutsu.K31.com.
@       IN      NS      shoko.jujutsu.K31.com.

utahime IN      A       10.79.1.2
shoko   IN      A       10.79.1.3
@       IN      A       10.79.1.2
EOF

named-checkconf
named-checkzone jujutsu.K31.com /etc/bind/db.jujutsu.K31.com