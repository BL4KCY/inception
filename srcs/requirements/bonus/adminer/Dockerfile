FROM alpine:3.21

WORKDIR /var/www/adminer

RUN apk update && apk add php curl bash  php-mysqli php-session php-json php-mbstring php-pdo php-pdo_mysql php-openssl

RUN curl -L -o /var/www/adminer/index.php\
    https://github.com/vrana/adminer/releases/download/v4.17.1/adminer-4.17.1.php

CMD [ "sh", "-c", "php -S 0.0.0.0:8080 -t /var/www/adminer"]

EXPOSE 8080