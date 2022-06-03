#!/bin/ash

# Configure IPTables
HOST_IP=$(ip route show | grep default | grep -oE '\d+\.\d+\.\d+\.\d+')
iptables -t nat -A PREROUTING -p tcp --dport 4242 -j DNAT --to-destination $HOST_IP:$DST_PORT
iptables -t nat -A POSTROUTING -p tcp --dport $DST_PORT -j SNAT --to $SPOOFED_IP

# Add a new IP to the cantainer's eth0 so it responds to ARP
ip addr add $SPOOFED_IP/32 dev eth0

# Print this container's IP
MY_IP=$(ip addr | grep eth0 | grep -oE 'inet \d+\.\d+\.\d+\.\d+' | grep -oE '\d+\.\d+\.\d+\.\d+' | grep -v "$SPOOFED_IP")
echo "Connection bouncer listening at: $MY_IP:4242"

# Wait until someone `Ctrl-C`s or `docker kill`s us
while true; do
    sleep 1
done