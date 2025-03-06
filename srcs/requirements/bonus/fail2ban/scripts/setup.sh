#!/bin/bash


mkdir -p /var/log/nginx  && touch  /var/log/nginx/access.log


iptables -N f2b-nginx-http-auth

fail2ban-server -f