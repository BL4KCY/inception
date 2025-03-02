#!/bin/bash


# config ftps

adduser -D $FTP_USER
echo "$FTP_USER:$FTP_PASSWORD" | chpasswd

chown -R $FTP_USER:$FTP_USER /var/www/html

# start vsftpd
vsftpd /etc/vsftpd/vsftpd.conf