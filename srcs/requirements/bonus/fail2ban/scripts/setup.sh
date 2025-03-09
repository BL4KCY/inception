#!/bin/bash


mkdir -p /var/log/nginx  && touch  /var/log/nginx/access.log

rm -f /var/run/fail2ban/fail2ban.sock /etc/fail2ban/jail.d/alpine-ssh.conf

iptables -N f2b-nginx-http-auth

fail2ban-server -f