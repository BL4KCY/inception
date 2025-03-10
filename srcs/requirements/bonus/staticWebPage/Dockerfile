FROM alpine:3.21

WORKDIR	/var/www/html

RUN apk update && apk add --no-cache nginx

COPY conf/default.conf /etc/nginx/http.d/default.conf

COPY src .

CMD [ "nginx", "-g", "daemon off;"]