FROM alpine:3.21

WORKDIR /var/www/html

RUN apk update && apk add --no-cache vsftpd bash vim

COPY  conf/vsftpd.conf /etc/vsftpd/vsftpd.conf

COPY  tools/setup.sh /

ENTRYPOINT ["bash", "/setup.sh" ]