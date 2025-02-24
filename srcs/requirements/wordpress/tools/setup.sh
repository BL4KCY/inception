#!/bin/bash

echo 'memory_limit = 256M' >> /etc/php83/php.ini

wp core download --path=/var/www/html --allow-root

# create wp-config.php
if [ ! -f /var/www/html/wp-config.php ]; then
    wp config create    --path=/var/www/html --dbname=$DB_NAME\
                        --dbuser=$DB_USER --dbpass=$DB_PASSWORD\
                        --dbhost=$DB_HOST --dbprefix=$DB_PREFIX\
                        --allow-root --skip-check

    wp config set WP_REDIS_HOST 'my_redis' --allow-root

    wp config set WP_REDIS_PORT '6379' --allow-root

    wp config set WP_CACHE true --allow-root

    wp config set WP_REDIS_SCHEME 'tcp' --allow-root
fi
# install wordpress
if ! $(wp core is-installed --path=/var/www/html --allow-root); then
    wp core install     --url=https://$DOMAIN_NAME --title=$TITLE\
                        --admin_user=$WP_ADMIN_USER --admin_password=$WP_ADMIN_PASSWORD\
                        --admin_email=$WP_ADMIN_EMAIL --allow-root
fi
# install redis cache plugin
if ! $(wp plugin is-installed redis-cache --path=/var/www/html --allow-root); then
    wp plugin install redis-cache --activate --allow-root #bonus
    wp redis enable --allow-root 
fi

php-fpm83 -F