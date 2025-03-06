FROM alpine:3.21

RUN apk add --no-cache fail2ban iptables bash

COPY conf/jail.conf /etc/fail2ban/jail.d/nginx.conf

RUN rm /etc/fail2ban/jail.d/alpine-ssh.conf

COPY scripts .

CMD ["bash", "setup.sh"]
