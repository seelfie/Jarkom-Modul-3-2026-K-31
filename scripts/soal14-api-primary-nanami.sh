cat > /var/www/html/api.php <<'BASH'
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
            PDO::ATTR_TIMEOUT => 5
        ]
    );

    $stmt = $pdo->prepare(
        'INSERT INTO request_logs
        (request_method, request_path, status_code)
        VALUES (?, ?, ?)'
    );

    stmt->execute([method, $path, 200]);

    header('Content-Type: application/json');
    echo json_encode([
        'server' => gethostname(),
        'method' => $method,
        'path' => $path,
        'message' => 'API OK'
    ]);
} catch (PDOException $e) {
    http_response_code(500);
    header('Content-Type: application/json');
    echo json_encode([
        'server' => gethostname(),
        'error' => 'Database connection or logging failed'
    ]);
}
BASH

chown www-data:www-data /var/www/html/api.php
chmod 644 /var/www/html/api.php
service php8.4-fpm restart
nginx -t && service nginx reload