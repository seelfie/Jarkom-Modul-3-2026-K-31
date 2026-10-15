cat > /etc/bind/named.conf.local << "EOF"
zone "jujutsu.K31.com" {
        type master;
        file "/etc/bind/db.jujutsu.K31.com";
        allow-transfer { 10.79.1.3; };
        also-notify { 10.79.1.3; };
};

zone "1.79.10.in-addr.arpa" {
        type master;
        file "/etc/bind/db.10.79.1";
        allow-transfer { 10.79.1.3; };
        also-notify { 10.79.1.3; };
};
EOF

cat > /etc/bind/db.10.79.1 << "EOF"
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
4       IN      PTR     jujutsu.K31.com.
EOF

named-checkconf && named-checkzone jujutsu.K31.com /etc/bind/db.jujutsu.K31.com &&  named-checkzone 1.79.10.in-addr.arpa /etc/bind/db.10.79.1