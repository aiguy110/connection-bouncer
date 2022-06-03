#/bin/bash
if [ -z "$1" ] || [ -z "$2" ]; then
    echo "Usage: ./launch_bouncer.sh <SPOOFED_IP> <DST_PORT>"
    exit
fi
SPOOFED_IP=$1
DST_PORT=$2

# Add a new routing rule and make sure it get's cleaned up when we finish
trap "echo \"Removing static route for $SPOOFED_IP\"; ip route delete $SPOOFED_IP dev docker0" EXIT
ip route add $SPOOFED_IP dev docker0

# Start the container
docker run --cap-add=NET_ADMIN -e SPOOFED_IP=$SPOOFED_IP -e DST_PORT=$DST_PORT -it aiguy110/connection-bouncer