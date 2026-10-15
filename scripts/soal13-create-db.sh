mariadb << 'SQL'
CREATE DATABASE IF NOT EXISTS db_shibuya_K31;

USE db_shibuya_K31;

CREATE TABLE IF NOT EXISTS request_logs (
        id INT AUTO_INCREMENT PRIMARY KEY,
        request_method VARCHAR(10) NOT NULL,
        request_path VARCHAR(255) NOT NULL,
        status_code INT,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
SQL

mariadb -e "SHOW TABLES FROM db_shibuya_K31;"