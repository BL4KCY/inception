FROM alpine:3.21

WORKDIR /setup

RUN apk update && apk add nginx openssl

COPY conf/default.conf /etc/nginx/http.d/default.conf

COPY tools/setup.sh .

RUN sh setup.sh

ENTRYPOINT [ "nginx", "-g", "daemon off;"]

EXPOSE 80 433