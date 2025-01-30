#!/bin/bash

is_first=1
if test -f /var/www/html/index.php; then
    is_first=0
fi
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

REDIS_AUTH=$(grep "password" /run/secrets/redis_auth | awk '{print $2}')

NGINX_IPADDR=$(host nginx | awk '{print $4}')
REDIS_IPADDR=$(host redis | awk '{print $4}')
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

#echo "listen.allowed_clients = $NGINX_IPADDR $REDIS_IPADDR" >> /etc/php/7.4/fpm/pool.d/www.conf

#echo "define( 'WP_CACHE', true );" >> wp-config.php
#echo "define( 'WP_CACHE_KEY_SALT', 'https://achak.42.fr' );" >> wp-config.php

if ! grep "$REDIS_IPADDR" wp-config.php; then
    # Mistake: I didnt put the redis server credentials in between the block that the wp-config.php file explicitly told us to write inside
    # for additional custom values, which resulted in wp-content/object-cache.php error at line 1490: Connection refused
    sed -n '91,$p' wp-config.php > tempfile
    sed -i '91,$d' wp-config.php
    if ! grep "redis_server" wp-config.php; then
        echo '$redis_server'" = array(
            'host'      => '$REDIS_IPADDR',
            'port'      => 6379,
            'auth'      => '$REDIS_AUTH',
            'database'  => 0,
        );" >> wp-config.php
    fi
    cat tempfile >> wp-config.php
    rm tempfile
fi

if test -f wp-content/object-cache.php; then
    wp plugin activate wp-redis
else

    wp plugin install wp-redis --activate
    cp wp-content/plugins/wp-redis/object-cache.php wp-content/object-cache.php
    #For printing out backtrace that led to php exception
    #sed -i 's/trigger_error( $this->last_triggered_error, E_USER_WARNING );/debug_print_backtrace();\n\t\t\ttrigger_error( $this->last_triggered_error, E_USER_WARNING );/g' wp-content/object-cache.php
fi

if [ $is_first -eq 1 ]; then
    # This line below will sometimes help solve the error when hyperlink to https://achak.42.fr/wp-admin/ doesn't work,
    # but entering it in search bar (regardless of line below) usually works
    # UPDATE: if the below script gets run after the first time, it changes https links to httpss, which will break the hyperlink to dashboard
    wp search-replace http https --report-changed-only
    echo "is_first condition hit"
else
    echo "condition not met"
fi
#wp cache flush
cat << EOF > /var/www/html/abc.php
<?php

phpinfo();
EOF

exec php-fpm -F -R
