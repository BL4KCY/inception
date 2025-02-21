FROM alpine:3.21

WORKDIR /var/www/html

COPY tools .

RUN apk add --no-cache php-fpm php-mysqli curl

RUN	adduser -D -G www-data www-data &&\
	chown -R www-data:www-data .

RUN sed -i 's|listen = 127.0.0.1:9000|listen = 0.0.0.0:9000|' /etc/php83/php-fpm.d/www.conf &&\
	sed -i 's|nobody|www-data|' /etc/php83/php-fpm.d/www.conf &&\
	sed -i 's|;clear_env|clear_env|' /etc/php83/php-fpm.d/www.conf

CMD [ "sh" , "setup.sh"]

EXPOSE 9000 3306