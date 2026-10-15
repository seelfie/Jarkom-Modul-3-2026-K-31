echo "=== Install Nginx, PHP-FPM, dan PHP MySQL ==="
apt-get update
apt-get install -y nginx php-fpm php-mysql

echo "=== Start services ==="
service nginx start
service php8.4-fpm start

echo "=== Configure Nginx ==="
cat > /etc/nginx/sites-available/default <<'NGINX'
server {
    listen 80 default_server;
    listen [::]:80 default_server;

    root /var/www/html;
    index index.php index.html index.htm;
    server_name _;

    location / {
        try_files $uri $uri/ =404;
    }

    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/run/php/php8.4-fpm.sock;
    }

    location ~ /\. {
        deny all;
    }
}
NGINX

echo "=== Test and reload Nginx ==="
nginx -t
service nginx reload

echo '<?php echo "PHP OK - " . gethostname(); ?>' > /var/www/html/test.php

echo "=== Test PHP ==="
curl http://127.0.0.1/test.php
echo
echo "=== Setup selesai ==="