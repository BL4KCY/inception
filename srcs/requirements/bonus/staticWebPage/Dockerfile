FROM alpine:3.21

WORKDIR /var/www/html

COPY tools .

RUN apk update && apk add php php-dom php-openssl bash vim

ENTRYPOINT [ "php", "-S", "0.0.0.0:8080"]

EXPOSE 8080