CONF="/etc/nginx/conf.d/soal16-gojo-routing.conf"
BACKUP="${CONF}.backup-soal19"

# Backup konfigurasi sebelumnya
cp "$CONF""$BACKUP"

# Pastikan direktori cache tersedia
mkdir -p /var/cache/nginx/frontend

# Tambahkan zona cache dan rate limit jika belum ada
if ! grep -q 'keys_zone=frontend_cache:' /etc/nginx/conf.d/soal19-cache-limit.conf 2>/dev/null; then
cat > /etc/nginx/conf.d/soal19-cache-limit.conf <<'NGINX'
proxy_cache_path /var/cache/nginx/frontend
    levels=1:2
    keys_zone=frontend_cache:10m
    max_size=100m
    inactive=10m
    use_temp_path=off;

limit_req_zone $binary_remote_addr zone=api_limit:10m rate=10r/s;
NGINX
fi

# Buat konfigurasi routing Soal 19
cat > "$CONF" <<'NGINX'
upstream frontend_cluster {
    server 10.79.4.4:80;
    server 10.79.4.5:80;
}

server {
    listen 80;
    server_name jujutsu.K31.com www.jujutsu.K31.com 10.79.1.4;

    location ^~ /api {
        limit_req zone=api_limit;
        limit_req_status 429;

        proxy_pass http://10.79.4.3:8080;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $remote_addr;
        proxy_set_header Host $host;
    }

    location / {
        proxy_pass http://frontend_cluster;

        proxy_cache frontend_cache;
        proxy_cache_valid 200 10m;
        proxy_cache_key "schemerequest_methodhostrequest_uri";
        proxy_cache_bypass $http_authorization;
        proxy_no_cache $http_authorization;
        add_header X-Cache-Status $upstream_cache_status always;

        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $remote_addr;
        proxy_set_header Host frontend.example.test;
    }
}
NGINX

# Validasi sebelum reload
nginx -t
service nginx restart

echo "Konfigurasi Soal 19 berhasil diterapkan."