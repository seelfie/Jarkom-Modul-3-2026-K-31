cat > /etc/bind/named.conf.local << 'EOF'
zone "jujutsu.K31.com" {
        type slave;
        masters { 10.79.1.2; }
        file "/var/cache/bind/db.jujutsu.K31.com";
}

named-checkconf