cat > /etc/nginx/conf.d/soal14-api.conf <<'NGINX'
upstream api_workers {
    server 10.79.4.6:80;
    server 10.79.4.7:80;
    server 10.79.4.8:80 backup;
}

server {
    listen 8080;
    server_name _;

    location / {
        proxy_pass http://api_workers;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }
}
NGINX

nginx -t
service nginx reload

echo "Konfigurasi reverse proxy API selesai."