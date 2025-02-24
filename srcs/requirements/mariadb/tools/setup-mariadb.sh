#!/bin/bash

mariadbd &

while ! mariadb-admin ping -hlocalhost --silent; do
	sleep 1;
done

mariadb -e "CREATE DATABASE IF NOT EXISTS $DB_NAME;"

mariadb -e "CREATE USER IF NOT EXISTS '$MYSQL_ADMIN_USER'@'%' IDENTIFIED BY '$MYSQL_ADMIN_PASSWORD';"

mariadb -e "GRANT ALL PRIVILEGES ON *.* TO '$MYSQL_ADMIN_USER'@'%' WITH GRANT OPTION;"

mariadb -e "CREATE USER IF NOT EXISTS '$DB_USER'@'%' IDENTIFIED BY '$DB_PASSWORD';"

mariadb -e "GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'%';"

mariadb -e "FLUSH PRIVILEGES;"

killall mariadbd

mariadbd