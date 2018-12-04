#!/bin/bash

while true; do
    curl -k -o /dev/null -s -w "Total-Time [%{time_total}] Response-Code [%{http_code}]\n" $1
    sleep $2
done 