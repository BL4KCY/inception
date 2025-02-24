FROM alpine:3.21

WORKDIR /var/www/html

COPY tools .

RUN apk add --no-cache php-ctype php-redis php-tokenizer php-mbstring php php-phar php-fpm php-mysqli curl bash

RUN	adduser -D -G www-data www-data &&\
	chown -R www-data:www-data .

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar &&\
	chmod +x wp-cli.phar &&\
	mv wp-cli.phar /usr/local/bin/wp

RUN sed -i 's|listen = 127.0.0.1:9000|listen = 0.0.0.0:9000|' /etc/php83/php-fpm.d/www.conf &&\
	sed -i 's|nobody|www-data|' /etc/php83/php-fpm.d/www.conf &&\
	sed -i 's|;clear_env|clear_env|' /etc/php83/php-fpm.d/www.conf

CMD [ "bash" , "setup.sh"]

EXPOSE 9000 3306 6379