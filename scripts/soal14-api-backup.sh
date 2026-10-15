echo "=== Soal 14: API Backup Kirara ==="

# 1. Update package list
apt-get update

# 2. Install kebutuhan API
apt-get install -y nginx php-fpm php-mysql mariadb-client curl lynx

# 3. Deteksi versi PHP
PHP_VERSION=$(php -r 'echo PHP_MAJOR_VERSION.".".PHP_MINOR_VERSION;')
PHP_FPM_SERVICE="php${PHP_VERSION}-fpm"
PHP_FPM_SOCKET="/run/php/php${PHP_VERSION}-fpm.sock"

# 4. Jalankan PHP-FPM
service "$PHP_FPM_SERVICE" start

# 5. Buat endpoint API
cat > /var/www/html/api.php <<'PHP'
<?php

$host = '10.79.4.9';
$db   = 'db_shibuya_K31';
$user = 'remote_user';
$pass = 'RemoteLab2026!';

$method = $_SERVER['REQUEST_METHOD'];
path=parseurl(_SERVER['REQUEST_URI'], PHP_URL_PATH);

try {
    $pdo = new PDO(
        "mysql:host=host;dbname=db;charset=utf8mb4",
        $user,
        $pass,
        [
            PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
            PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
            PDO::ATTR_TIMEOUT => 5
        ]
    );

    $stmt = $pdo->prepare(
        'INSERT INTO request_logs
         (request_method, request_path, status_code)
         VALUES (:method, :path, :status)'
    );

    $stmt->execute([
        ':method' => $method,
        ':path' => $path,
        ':status' => 200
    ]);

    http_response_code(200);
    header('Content-Type: application/json; charset=utf-8');

    echo json_encode([
        'server' => gethostname(),
        'method' => $method,
        'path' => $path,
        'message' => 'API OK'
    ]);

} catch (PDOException $e) {
    error_log('API database error: ' . $e->getMessage());

    http_response_code(500);
    header('Content-Type: application/json; charset=utf-8');

    echo json_encode([
        'server' => gethostname(),
        'error' => 'Database connection or logging failed'
    ]);
}
PHP

# 6. Atur permission
chown www-data:www-data /var/www/html/api.php
chmod 644 /var/www/html/api.php

# 7. Konfigurasi Nginx + PHP-FPM
cat > /etc/nginx/sites-available/default <<NGINX
server {
    listen 80 default_server;
    listen [::]:80 default_server;

    root /var/www/html;
    index index.php index.html;
    server_name _;

    location / {
        try_files \$uri \$uri/ =404;
    }

    location ~ \\.php\$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:${PHP_FPM_SOCKET};
    }

    location ~ /\\. {
        deny all;
    }
}
NGINX

# 8. Validasi dan jalankan layanan
php -l /var/www/html/api.php
nginx -t
service nginx start
service "$PHP_FPM_SERVICE" restart
service nginx reload