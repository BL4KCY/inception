#!/bin/bash


# config ftps

adduser -D $FTP_USER
echo "$FTP_USER:$FTP_PASSWORD" | chpasswd

# start vsftpd
vsftpd /etc/vsftpd/vsftpd.conf