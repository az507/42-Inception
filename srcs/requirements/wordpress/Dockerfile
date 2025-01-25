FROM debian:11

RUN apt-get update -y && apt-get install -y \
host \
curl \
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
php7.4-fpm #&& rm -rf /var/lib/apt/lists/*

# Without creating this directory the php-fpm process wont be able to create some pid file in /run/php/php7.4-fpm.pid
RUN cp /usr/sbin/php-fpm7.4 /bin/php-fpm && mkdir /run/php /home/wordpress
COPY conf/php.ini /etc/php/7.4/fpm
COPY conf/www.conf /etc/php/7.4/fpm/pool.d
COPY tools/entrypoint.sh conf/wp-config.php /run/php

# Download wp cli, which helps us to install and setup wordpress
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
RUN chmod +x wp-cli.phar && mv wp-cli.phar /usr/local/bin/wp

WORKDIR /var/www/html
VOLUME /var/www/html
RUN groupadd -r -g 1000 wordpress && useradd -u 1000 -r -g wordpress wordpress && touch /var/log/php7.4-fpm.log
RUN chown -R wordpress:wordpress /run/php /etc/php /var/www/html /var/log/php7.4-fpm.log /home/wordpress
USER wordpress

CMD ["/run/php/entrypoint.sh"]
