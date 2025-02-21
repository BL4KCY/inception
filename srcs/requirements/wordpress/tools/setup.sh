#!/bin/sh

if [ ! -f wp-config.php ]; then
	echo "Downloading WordPress..."
	curl -O -s https://wordpress.org/latest.tar.gz
	tar -xzf latest.tar.gz
	mv wordpress/* .
	rm -rf wordpress latest.tar.gz

	curl -s https://api.wordpress.org/secret-key/1.1/salt/ > /tmp/auth_keys.txt

	DEFAULT_AUTHEN="define( 'AUTH_KEY',         'put your unique phrase here' );"

	if [ ! -f wp-config.php ]; then
		echo "Configuring WordPress..."
		cp wp-config-sample.php wp-config.php
		sed -i "s|database_name_here|$DB_NAME|g" wp-config.php
		sed -i "s|username_here|$DB_USER|g" wp-config.php
		sed -i "s|password_here|$DB_PASSWORD|g" wp-config.php
		sed -i "s|localhost|$DB_HOST|g" wp-config.php
		sed -i "s|wp_|$DB_PREFIX|g" wp-config.php
		sed -i "/define( 'AUTH_KEY'/,/define( 'NONCE_SALT'/d" wp-config.php
		sed -i "/#@-/r /tmp/auth_keys.txt" wp-config.php
	fi
	rm -f /tmp/auth_keys.txt
fi

php-fpm83 -F