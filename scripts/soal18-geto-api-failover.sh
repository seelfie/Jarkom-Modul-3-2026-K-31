apt-get update
apt-get install -y nginx

CONF="/etc/nginx/conf.d/soal14-api.conf"

if [ -f "$CONF" ]; then
    cp "CONF""{CONF}.backup-soal18"
fi

cat > "$CONF" <<'NGINX'
upstream api_cluster {
    server 10.79.4.6:80 max_fails=2 fail_timeout=5s;
    server 10.79.4.7:80 max_fails=2 fail_timeout=5s;
    server 10.79.4.8:80 backup;
}

server {
    listen 8080;
    server_name _;

    location / {
        proxy_pass http://api_cluster;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $remote_addr;
    }
}
NGINX

nginx -t
service nginx reload

echo "Konfigurasi Soal 18 selesai di $(hostname)."
