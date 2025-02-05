FROM debian:11
RUN apt-get update -y && apt-get upgrade -y && apt-get install -y \
host \
`#less` \
`#sendmail <-- Massively slows down wordpress startup time` \
curl \
php-pear `# php-pear is for pecl installer, used for downloading PhpRedis extension` \
#xdg-utils \
php-curl \
php-dom \
php-igbinary \
php-imagick \
php-intl \
php-xml \
php-zip \
php-mbstring \
php7.4-mysqli \
php7.4-fpm \
php-redis `# <-- for downloading PhpRedis extension` \
php7.4-dev `# <-- This package is to resolve 'phpize' error that shows up when running below 'pecl instal'` \
vim \
mariadb-client && rm -rf /var/lib/apt/lists/*

#src: https://askubuntu.com/questions/403327/install-pecl-packages-on-ubuntu

RUN pecl install redis # <-- for downloading PhpRedis extension as well

# Without creating this directory the php-fpm process wont be able to create some pid file in /run/php/php7.4-fpm.pid
RUN cp /usr/sbin/php-fpm7.4 /bin/php-fpm && mkdir /run/php /home/wordpress
COPY conf/php.ini /etc/php/7.4/fpm
COPY conf/www.conf /etc/php/7.4/fpm/pool.d
COPY tools/entrypoint.sh conf/wp-config.php /run/php
#COPY tools/entrypoint.sh /run/php

# Download wp cli, which helps us to install and setup wordpress
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
RUN chmod +x wp-cli.phar && mv wp-cli.phar /usr/local/bin/wp

WORKDIR /var/www/html
VOLUME /var/www/html
RUN groupadd -r -g 1002 wordpress && useradd -u 1002 -r -g wordpress wordpress && touch /var/log/php7.4-fpm.log
RUN chown -R wordpress:wordpress /run/php /etc/php /var/www/html /var/log/php7.4-fpm.log /home/wordpress
USER wordpress

ARG DB_NAME
ARG DB_USER
ARG ADMIN_USER
ARG ADMIN_EMAIL

RUN wp core download #--path=/var/www/html
#RUN --mount=type=secret,id=db_password,env=DB_PASS \

# Dont run this command below, they create a config file with the "For developers: Wordpress debugging mode" in the block
# for adding any custom values
#RUN wp config create --dbname=${DB_NAME} --dbuser=${DB_USER} --dbpass=dbpass123 --dbhost=mariadb --skip-check
#RUN --mount=type=secret,id=user_password.txt,env=USER_PASS \
#wp user create ${USER_NAME} ${USER_EMAIL} --user_pass=${USER_PASS}
#wp db create && wp user create ${USER_NAME} ${USER_EMAIL} --user_pass=${USER_PASS}
#RUN --mount=type=secret,id=admin_password,env=ADMIN_PASS \
#wp core install --url=${WEBSITE_URL} --title=${WEBSITE_TITLE} --admin_user=${ADMIN_NAME} --admin_password=${ADMIN_PASS} --admin_email=${ADMIN_EMAIL}

CMD ["/run/php/entrypoint.sh"]
