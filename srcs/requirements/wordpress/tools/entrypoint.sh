#!/bin/bash

wp core download --path=/var/www/html
# Don't use wp config create and wp db create, these commands rely on the mysql binary being on the same host machine
# as the wp cli, not for remote client access
#wp config create --dbname=$DB_NAME --dbuser=$DB_USER --dbpass=$DB_PASS
#wp db create
mv /run/php/wp-config.php /var/www/html

DB_NAME=$(grep "database_name" /run/secrets/wpdb_credentials | awk '{print $2}')
DB_USER=$(grep "database_user" /run/secrets/wpdb_credentials | awk '{print $2}')
DB_PASS=$(grep "database_pass" /run/secrets/wpdb_credentials | awk '{print $2}')

ADMIN_NAME=$(grep "username" /run/secrets/wp_admin_credentials | awk '{print $2}')
ADMIN_PASS=$(grep "password" /run/secrets/wp_admin_credentials | awk '{print $2}')
ADMIN_EMAIL=$(grep "email" /run/secrets/wp_admin_credentials | awk '{print $2}')

USER_NAME=$(grep "username" /run/secrets/wp_credentials | awk '{print $2}')
USER_PASS=$(grep "password" /run/secrets/wp_credentials | awk '{print $2}')
USER_EMAIL=$(grep "email" /run/secrets/wp_credentials | awk '{print $2}')

NGINX_IPADDR=$(host nginx | awk '{print $4}')
HOSTNAME=$COMPOSE_PROJECT_NAME-mariadb-1.$COMPOSE_PROJECT_NAME''_back-end

sed -i 's@database_name_here@'"$DB_NAME"'@' wp-config.php
sed -i 's@username_here@'"$DB_USER"'@' wp-config.php
sed -i 's@password_here@'"$DB_PASS"'@' wp-config.php
sed -i 's@localhost@'"$HOSTNAME"'@' wp-config.php

wp core install --url=$WEBSITE_URL \
    --title="$WEBSITE_TITLE" \
    --admin_user=$ADMIN_NAME \
    --admin_password=$ADMIN_PASS \
    --admin_email=$ADMIN_EMAIL
wp user create $USER_NAME $USER_EMAIL --user_pass=$USER_PASS
echo "listen.allowed_clients = $NGINX_IPADDR" >> /etc/php/7.4/fpm/pool.d/www.conf

# This line below will sometimes help solve the error when hyperlink to https://achak.42.fr/wp-admin/ doesn't work,
# but entering it in search bar (regardless of line below) usually works
wp search-replace http https --report-changed-only
exec php-fpm -F -R
