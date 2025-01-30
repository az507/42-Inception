#!/bin/bash

REDIS_IPADDR=$(host redis | awk '{print $4}')
REDIS_AUTH=$(grep "password" /run/secrets/redis_auth | awk '{print $2}')

while ! redis-cli -h $REDIS_IPADDR ping
do
    sleep 1
done
echo "Done pinging!"

# SET operations will store the cache data, (sets string value of key, creating it if doesn't exist)
# GET operations retrieve it (gets value of key)
redis-cli Config Set requirepass $REDIS_AUTH
exec redis-cli -h $REDIS_IPADDR << EOF
Auth $REDIS_AUTH
MONITOR
EOF
