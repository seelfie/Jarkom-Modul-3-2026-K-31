apt-get update
apt-get install -y mariadb-server mariadb-client

mkdir -p /var/log/mysql
chown mysql:mysql /var/log/mysql
chmod 750 /var/log/mysql

cat > /etc/mysql/mariadb.conf.d/60-replication.cnf << 'CONF'
[mysqld]
server-id = 5
relay_log = /var/log/mysql/mariadb-relay-bin
bind-address = 0.0.0.0
CONF

service mariadb restart

mariadb -e "SHOW VARIABLES LIKE 'server_id';"
mariadb -e "SHOW VARIABLES LIKE 'relay_log';"