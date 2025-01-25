#!/bin/bash

while ! mysqladmin ping
do
    sleep 1
done

# For the host portion of account eg wordpress.mynet, we have to use the network name provided by docker network
# Check the docker compose logs of mariadb service to see what 'host' name they are looking for, eg:
# mariadb-1  | 2025-01-23  8:42:10 5 [Warning] Aborted connection 5 to db: 'unconnected' user: 'unauthenticated'
# host: 'abc-wordpress-1.abc_back-end' (This connection closed normally without authentication)

ROOT_PASS=$(grep "root_pass" /run/secrets/wpdb_credentials | awk '{print $2}')
DB_NAME=$(grep "database_name" /run/secrets/wpdb_credentials | awk '{print $2}')
DB_USER=$(grep "database_user" /run/secrets/wpdb_credentials | awk '{print $2}')
DB_PASS=$(grep "database_pass" /run/secrets/wpdb_credentials | awk '{print $2}')

HOSTNAME=$COMPOSE_PROJECT_NAME-wordpress-1.$COMPOSE_PROJECT_NAME''_back-end

mariadb -u mariadb -p$'\n' << EOF
ALTER USER 'root'@'localhost' IDENTIFIED BY '$ROOT_PASS';
ALTER USER 'mariadb'@'localhost' IDENTIFIED BY '$ROOT_PASS';
CREATE DATABASE IF NOT EXISTS $DB_NAME;
CREATE USER '$DB_USER'@'$HOSTNAME' IDENTIFIED BY '$DB_PASS';
GRANT ALL PRIVILEGES ON *.* TO '$DB_USER'@'$HOSTNAME' WITH GRANT OPTION;
FLUSH PRIVILEGES;
EOF
