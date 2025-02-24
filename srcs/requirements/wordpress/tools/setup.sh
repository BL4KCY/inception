#!/bin/bash

echo 'memory_limit = 256M' >> /etc/php83/php.ini

# create wp-config.php
if [ ! -f /var/www/html/wp-config.php ]; then
    wp core download --path=/var/www/html --allow-root
    echo "Wordpress downloaded ✅"
    wp config create    --path=/var/www/html --dbname=$DB_NAME\
                        --dbuser=$DB_USER --dbpass=$DB_PASSWORD\
                        --dbhost=$DB_HOST --dbprefix=$DB_PREFIX\
                        --allow-root --skip-check
    wp config set WP_REDIS_HOST 'my_redis' --allow-root

    wp config set WP_REDIS_PORT '6379' --allow-root

    wp config set WP_CACHE true --allow-root --type=constant

    wp config set WP_REDIS_SCHEME 'tcp' --allow-root
    echo "wp-config.php created ✅"
fi
# install wordpress


if ! $(wp core is-installed --path=/var/www/html --allow-root > /dev/null 2>&1); then
    until $(wp core install     --title=$TITLE --admin_user=$WP_ADMIN_USER\
                        --admin_password=$WP_ADMIN_PASSWORD\
                        --admin_email=$WP_ADMIN_EMAIL\
                        --url="https://$DOMAIN_NAME"\
                        --allow-root > /dev/null 2>&1); do
        for i in {3..1}; do
            printf "\rWordPress is not installed yet ⛔️, retrying in %d seconds ⏳" "$i"
            sleep 1
        done
        printf "\rWordPress is not installed yet ⛔️, retrying now...         "
    done
    printf "\rWordPress installed ✅                                      \n"
fi
# install redis cache plugin
if ! $(wp plugin is-installed redis-cache --path=/var/www/html --allow-root); then
    wp plugin install redis-cache --activate --allow-root #bonus
    echo "Redis cache plugin installed ✅"
    wp redis enable --allow-root 
    echo "Redis cache plugin enabled ✅"
fi

php-fpm83 -F;