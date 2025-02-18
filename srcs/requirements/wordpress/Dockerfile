FROM alpine:3.21

WORKDIR /var/www/html

COPY tools .

RUN apk add --no-cache php-fpm php-mysqli curl

CMD [ "sh" , "setup.sh"]

EXPOSE 9000 3306