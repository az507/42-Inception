#!/bin/bash

mysql_install_db --user=mariadb --datadir=/var/lib/mysql
/usr/lib/mysql/create_usr.sh &
exec su mariadb -c /usr/sbin/mariadbd
