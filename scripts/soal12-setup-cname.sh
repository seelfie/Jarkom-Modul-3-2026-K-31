cat > /etc/bind/db.jujutsu.K31.com << 'EOF'
$TTL    86400
@       IN      SOA     utahime.jujutsu.K31.com. admin.jujutsu.K31.com. (
                2026101403
                3600
                1800
                604800
                86400
)

@       IN      NS      utahime.jujutsu.K31.com.
@       IN      NS      shoko.jujutsu.K31.com.

utahime IN      A       10.79.1.2
shoko   IN      A       10.79.1.3
@       IN      A       10.79.1.4

www     IN      CNAME   jujutsu.K31.com.
EOF
