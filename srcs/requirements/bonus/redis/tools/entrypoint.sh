#!/bin/bash

WORDPRESS_IPADDR=$(host wordpress)

sed -i 's/bind/#bind/g' redis.conf
sed -i 's/protected-mode yes/protected-mode no/g' redis.conf
#echo "\nprotected-mode no" >> redis.conf
#echo "bind "$WORDPRESS_IPADDR >> redis.conf
#echo "WORDPRESS_IPADDR = $WORDPRESS_IPADDR"
/tools/setup_auth.sh &
# Do not pass the config file to redis-server as a command-line argument, it immediately returns
# the command prompt even though the server was started successfully, resulting in early termination
# of the docker container. Instead, edit the default config file /etc/redis/redis.conf and start
# the redis-server with no arguments
exec redis-server
