apt-get update
apt-get install -y mariadb-server mariadb-client

cat > /etc/mysql/mariadb.conf.d/60-replication.cnf << "EOF"
[mysqld]
server-id = 4
log_bin = /var/log/mysql/mariadb-bin
binlog_format = ROW
bind-address = 0.0.0.0
EOF

service mariadb restart