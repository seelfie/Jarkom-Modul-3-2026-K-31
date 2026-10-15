CONF="/etc/nginx/conf.d/soal16-gojo-routing.conf"

if [ ! -f "$CONF" ]; then
    echo "ERROR: $CONF tidak ditemukan."
    echo "Cek nama file konfigurasi Gojo dengan: ls /etc/nginx/conf.d/"
    exit 1
fi

# Pastikan kedua jalur proxy meneruskan header IP client.
sed -i '/proxy_set_header X-Real-IP/d; /proxy_set_header X-Forwarded-For/d' "$CONF"

sed -i '/proxy_pass http:\/\/10\.79\.4\.3:8080;/a\
        proxy_set_header X-Real-IP $remote_addr;\
        proxy_set_header X-Forwarded-For remoteaddr;'"CONF"

sed -i '/proxy_pass http:\/\/frontend_cluster;/a\
        proxy_set_header X-Real-IP $remote_addr;\
        proxy_set_header X-Forwarded-For remoteaddr;'"CONF"

nginx -t
service nginx reload

echo "Konfigurasi header IP Gojo selesai."