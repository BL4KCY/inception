#!/bin/sh

if [ ! -f /etc/ssl/certs/nginx-selfsigned.crt ] || [ ! -f /etc/ssl/private/nginx-selfsigned.key ]; then
	mkdir -p /etc/ssl/certs /etc/ssl/private

	openssl req -x509 -nodes -days 365 \
	-newkey rsa:2048 \
	-keyout /etc/ssl/private/nginx-selfsigned.key \
	-out /etc/ssl/certs/nginx-selfsigned.crt \
	-subj "/C=MA/ST=RSK/L=SSC/O=1337/OU=42/CN=melfersi"
fi