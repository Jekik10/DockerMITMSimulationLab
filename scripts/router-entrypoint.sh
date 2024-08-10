#!/bin/sh

# Enable IP forwarding
echo 1 > /proc/sys/net/ipv4/ip_forward 

# Enable Masquerading
# iptables -t nat -A POSTROUTING -o eth2 -j MASQUERADE
# iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE

# Rules to clone traffic from 172.20.0.2
tc qdisc add dev eth0 ingress
tc filter add dev eth0 parent ffff: protocol ip u32 match ip src 172.20.0.2 action mirred egress mirror dev eth1

# Keeps the container running
exec "$@"
  