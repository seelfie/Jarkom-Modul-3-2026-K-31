apt update
DEBIAN_FRONTEND=noninteractive apt install -y nginx curl
mkdir -p /etc/nginx/conf.d

cat > /etc/nginx/conf.d/soal16-gojo-routing.conf <<'NGINX'
upstream frontend_cluster {
    server 10.79.4.4:80;
    server 10.79.4.5:80;
}

server {
    listen 80;
    server_name jujutsu.K31.com www.jujutsu.K31.com;

    location ^~ /api {
        proxy_pass http://10.79.4.3:8080;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }

    location / {
        proxy_pass http://frontend_cluster;
        proxy_set_header Host frontend.example.test;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }
}
NGINX

echo "=== Validasi konfigurasi Nginx ==="
nginx -t

echo "=== Aktifkan Nginx ==="
service nginx restart

echo "=== Status Nginx ==="
service nginx status

echo "=== Konfigurasi Soal 16 berhasil ==="