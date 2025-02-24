FROM alpine:3.21

WORKDIR /setup

RUN apk update && apk add --no-cache nginx openssl bash

COPY conf/default.conf /etc/nginx/http.d/default.conf

COPY tools/setup.sh .

CMD [ "bash", "setup.sh"]

EXPOSE 80 433