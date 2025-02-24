#!/bin/bash

echo 'memory_limit = 256M' >> /etc/php83/php.ini


wp core download --path=/var/www/html --allow-root

# create wp-config.php
wp config create    --path=/var/www/html --dbname=$DB_NAME\
                    --dbuser=$DB_USER --dbpass=$DB_PASSWORD\
                    --dbhost=$DB_HOST --dbprefix=$DB_PREFIX\
                    --allow-root --skip-check
wp config set WP_REDIS_HOST 'my_redis' --allow-root

wp config set WP_REDIS_PORT '6379' --allow-root

wp config set WP_CACHE true --allow-root

wp config set WP_REDIS_SCHEME 'tcp' --allow-root
# install wordpress
wp core install     --title=$TITLE --admin_user=$WP_ADMIN_USER\
                    --admin_password=$WP_ADMIN_PASSWORD\
                    --admin_email=$WP_ADMIN_EMAIL\
                    --url="https://$DOMAIN_NAME"\
                    --allow-root
# install redis cache plugin
if ! $(wp plugin is-installed redis-cache --path=/var/www/html --allow-root); then
    wp plugin install redis-cache --activate --allow-root #bonus
fi

php-fpm83 -F;