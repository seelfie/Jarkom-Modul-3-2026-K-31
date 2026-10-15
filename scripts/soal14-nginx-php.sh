apt-get update
apt-get install nginx php-fpm php-mysql -y

systemctl enable --now nginx
systemctl enable --now php*-fpm

ls /run/php/
hostname

cat > /var/www/html/index.php << "EOF"
<?php
$hostname = gethostname();
?>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <title>Frontend Worker</title>
</head>
<body>
    <h1>Frontend berhasil diakses!</h1>
    <p>Hostname: <?= htmlspecialchars($hostname) ?></p>
</body>
</html>
EOF

cat > /etc/nginx/sites-available/frontend << "EOF"
server {
    listen 80;
    server_name frontend.example.test;

    root /var/www/html;
    index index.php index.html;

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
EOF

ln -sf /etc/nginx/sites-available/frontend \
    /etc/nginx/sites-enabled/frontend

rm -f /etc/nginx/sites-enabled/default

nginx -t && systemctl reload nginx