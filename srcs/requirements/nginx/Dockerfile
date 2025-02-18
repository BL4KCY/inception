FROM alpine:3.21

WORKDIR /var/www/html

RUN apk update && apk add nginx

COPY ./conf/nginx.conf /etc/nginx/nginx.conf

# COPY ./website ./website

COPY ./tools /etc/ssl/

CMD [ "nginx", "-g", "daemon off;" ]

EXPOSE 80 433