#!/bin/bash
#set -x
echo "$green ==> Starting ekino/haproxy:base$reset"

SSL_DEFAULT="/etc/ssl/private/haproxy.pem"
if [ -z ${SSL_CERT} ] || [ ! -f $SSL_DEFAULT ]
then
  SSL_CERT="$SSL_DEFAULT"
fi

if [ ! -f "$SSL_CERT" ]
then
  echo "$cyan --> Setting SSL certificate$reset"
  mkdir -pv "$(dirname $SSL_CERT)"
  openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout "$SSL_CERT" -out "$SSL_CERT" -batch
else
  echo "$cyan --> SSL certificate already setup$reset"
fi

