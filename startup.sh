#!/bin/bash

# Settings on/off
if [ ! -z "$INTERFACE" ]; then
    sed -i "s/eth0/$INTERFACE/g" /etc/accel-ppp.conf
fi

if [ ! -z "$PPPOE_AC_NAME" ]; then
    sed -i "s/#ac-name=/ac-name=$PPPOE_AC_NAME/g" /etc/accel-ppp.conf
fi

if [ ! -z "$PPPOE_SERVICE_NAME" ]; then
    sed -i "s/#service-name=/service-name=$PPPOE_SERVICE_NAME/g" /etc/accel-ppp.conf
fi

if [ ! -z "$RADIUS" ]; then
    sed -i "s/server=freeradius,testing123/server=$RADIUS,$RADIUS_PASSWORD/g" /etc/accel-ppp.conf
    sed -i "s/dae-server=127.0.0.1:3799,testing123/dae-server=127.0.0.1:3799,$RADIUS_PASSWORD/g" /etc/accel-ppp.conf
fi

# Protocols on/off
if [ "$PPPOE" == "1" ]; then
    sed -i "s/#pppoe/pppoe/g" /etc/accel-ppp.conf
fi

if [ "$IPOE" == "1" ]; then
    sed -i "s/#ipoe/ipoe/g" /etc/accel-ppp.conf
fi

if [ "$PPTP" == "1" ]; then
    sed -i "s/#pptp/pptp/g" /etc/accel-ppp.conf
fi

if [ "$L2TP" == "1" ]; then
    sed -i "s/#l2tp/l2tp/g" /etc/accel-ppp.conf
fi

if [ "$SSTP" == "1" ]; then
    sed -i "s/#sstp/sstp/g" /etc/accel-ppp.conf
fi

# Dead loop, if accel dies it will be restarted in 5 seconds
while true
do
    echo "Starting accel"
    accel-pppd -c /etc/accel-ppp.conf
    sleep 5
done