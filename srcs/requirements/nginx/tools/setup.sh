#!/bin/bash

sed -i "s|\[CERTS_\]|$CERTS_|g" /etc/nginx/http.d/default.conf
sed -i "s|\[DOMAIN_NAME\]|$DOMAIN_NAME|g" /etc/nginx/http.d/default.conf

if [ ! -f $CERTS_/nginx-selfsigned.crt ] || [ ! -f $CERTS_/private/nginx-selfsigned.key ]; then
	mkdir -p $CERTS_ $CERTS_/private

	openssl req -x509 -nodes -days 365 \
	-newkey rsa:2048 \
	-keyout $CERTS_/private/nginx-selfsigned.key \
	-out $CERTS_/nginx-selfsigned.crt \
	-subj "/C=$COUNTRY/ST=$STATE/L=$LOCALITY/O=$ORGANIZATION/OU=$ORGANIZATION_UNIT/CN=$COMMON_NAME"
fi

nginx -g "daemon off;"