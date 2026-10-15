cat > /etc/nginx/conf.d/soal14-api.conf <<'NGINX'
upstream api_cluster {
    server 10.79.4.6:80 weight=3;
    server 10.79.4.7:80 weight=1;
}

server {
    listen 8080;
    server_name _;

    location / {
        proxy_pass http://api_cluster;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }
}
NGINX

echo "=== Memeriksa konfigurasi Nginx ==="
nginx -t

echo "=== Reload Nginx ==="
service nginx reload

echo "=== Menguji 20 request ke API load balancer ==="
for i in $(seq 1 20); do
    curl -s --max-time 5 http://127.0.0.1:8080/api.php
    echo
done

echo "=== Rekap distribusi respons ==="
for i in $(seq 1 20); do
    curl -s --max-time 5 http://127.0.0.1:8080/api.php
    echo
done | grep -o '"server":"[^"]*"' | sort | uniq -c

echo "=== Pengujian selesai ==="