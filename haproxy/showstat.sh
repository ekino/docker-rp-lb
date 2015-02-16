#!/bin/bash

echo "show stat" | socat stdio /var/run/haproxy.sock | awk -F ',' '{printf("%-30s %-30s %-7s\n",$1,$2,$18)}'
