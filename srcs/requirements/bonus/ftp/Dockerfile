FROM alpine:3.21

WORKDIR /var/www/html

RUN apk update && apk add --no-cache vsftpd bash vim

COPY  conf/vsftpd.conf /etc/vsftpd/vsftpd.conf

COPY  tools/setup.sh /

EXPOSE 20-21 60000-60010

ENTRYPOINT ["bash", "/setup.sh" ]