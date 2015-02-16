#!/bin/bash
#set -x
echo "$green ==> Starting ekino/haproxy:base$reset"

echo "$cyan --> Setting ssl certificate$reset"

SSL_DEFAULT="/etc/ssl/private/haproxy.pem"
if [ -z ${SSL_CERT} ] || [ ! -f $SSL_DEFAULT ]
then
  SSL_CERT="$SSL_DEFAULT"
fi

mkdir -pv "$(dirname $SSL_CERT)"
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout "$SSL_CERT" -out "$SSL_CERT" -batch

