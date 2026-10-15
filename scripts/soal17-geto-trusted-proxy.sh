#!/bin/bash
set -e

apt update
DEBIAN_FRONTEND=noninteractive apt install -y nginx

CONF="/etc/nginx/conf.d/soal14-api.conf"

if [ ! -f "$CONF" ]; then
    echo "ERROR: $CONF tidak ditemukan. Cek konfigurasi Soal 15."
    exit 1
fi

cp "CONF""{CONF}.backup-soal17"

# Bersihkan konfigurasi lama; tambahkan real_ip config di server API.
python3 - <<'PY'
from pathlib import Path

p = Path("/etc/nginx/conf.d/soal14-api.conf")
s = p.read_text()

# Tambahkan trusted proxy hanya di dalam server yang listen 8080.
marker = "    listen 8080;"
if marker not in s:
    raise SystemExit("ERROR: server listen 8080 tidak ditemukan.")

s = s.replace(
    marker,
    marker + """
    set_real_ip_from 10.79.1.4;
    real_ip_header X-Real-IP;
    real_ip_recursive off;
""",
    1
)

# Forward alamat client yang sudah diverifikasi ke API worker.
s = s.replace(
    "proxy_set_header X-Real-IP $remote_addr;",
    "proxy_set_header X-Real-IP $remote_addr;"
)
s = s.replace(
    "proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;",
    "proxy_set_header X-Forwarded-For $remote_addr;"
)

p.write_text(s)
PY

nginx -t
service nginx reload

echo "Konfigurasi Geto selesai."