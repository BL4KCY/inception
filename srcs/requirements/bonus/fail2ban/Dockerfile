FROM alpine:3.21

RUN apk add --no-cache fail2ban iptables bash

COPY conf/jail.conf /etc/fail2ban/jail.d/nginx.conf

COPY conf/nginx-4xx.conf /etc/fail2ban/filter.d/nginx-4xx.conf

COPY scripts .

CMD ["bash", "setup.sh"]
