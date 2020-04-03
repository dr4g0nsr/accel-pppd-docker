#!/bin/bash

while true
do
    echo "Starting accel"
    accel-pppd -c /etc/accel-ppp.conf
    sleep 5
done