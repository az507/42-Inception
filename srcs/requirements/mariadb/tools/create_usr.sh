#!/bin/bash

ROOT_PASS=$(cat /run/secrets/db_root_password)

# For some reason, the --password=$ROOT_PASS below will work (and is needed) even though I only add the password at the bottom of file
#while ! mysqladmin ping
while ! mysqladmin ping
do
    sleep 1
done

echo "MYSQLADMIN PING DONE"

mysql_secure_installation << EOF

n
n




EOF

# For the host portion of account eg wordpress.mynet, we have to use the network name provided by docker network
# Check the docker compose logs of mariadb service to see what 'host' name they are looking for, eg:
# mariadb-1  | 2025-01-23  8:42:10 5 [Warning] Aborted connection 5 to db: 'unconnected' user: 'unauthenticated'
# host: 'abc-wordpress-1.abc_back-end' (This connection closed normally without authentication)

#ROOT_PASS=$(grep "root_pass" /run/secrets/wpdb_credentials | awk '{print $2}')
#DB_NAME=$(grep "database_name" /run/secrets/wpdb_credentials | awk '{print $2}')
#DB_USER=$(grep "database_user" /run/secrets/wpdb_credentials | awk '{print $2}')
#DB_PASS=$(grep "database_pass" /run/secrets/wpdb_credentials | awk '{print $2}')

HOSTNAME=$COMPOSE_PROJECT_NAME-wordpress-1.$COMPOSE_PROJECT_NAME''_back-end
#DB_NAME=wordpress
#DB_USER=new_user
#HOSTNAME=wordpress

#mariadb -u root -p$'\n' << EOF
##ALTER USER 'root'@'localhost' IDENTIFIED BY 'root123';
##ALTER USER 'mariadb'@'localhost' IDENTIFIED BY 'root123';
#CREATE DATABASE IF NOT EXISTS $DB_NAME;
#CREATE USER '$DB_USER'@'$HOSTNAME' IDENTIFIED BY 'dbpass123';
#GRANT ALL PRIVILEGES ON *.* TO '$DB_USER'@'$HOSTNAME' WITH GRANT OPTION;
#FLUSH PRIVILEGES;
#EOF

# This script is run as root, because I can't login to mariadb root user without it if my root user has no password.
# After I add a password to my root user (with the ALTER line below), then I don't have this restriction anymore

echo "db name = $DB_NAME, db user = $DB_USER, hostname = $HOSTNAME, root pass = $ROOT_PASS"

mariadb -u root << EOF
ALTER USER 'root'@'localhost' IDENTIFIED BY '$ROOT_PASS';
CREATE DATABASE IF NOT EXISTS $DB_NAME;
CREATE USER '$DB_USER'@'$HOSTNAME' IDENTIFIED BY '$(cat /run/secrets/db_password)';
GRANT ALL PRIVILEGES ON *.* TO '$DB_USER'@'$HOSTNAME' WITH GRANT OPTION;
FLUSH PRIVILEGES;
EOF

echo "END OF SCRIPT"
