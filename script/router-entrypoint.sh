#!/bin/sh

# Abilita l'inoltro IP
echo 1 > /proc/sys/net/ipv4/ip_forward 

# # Configura le rotte statiche
# ip route add 172.21.0.0/24 via 172.20.0.3 dev eth0
# ip route add 172.20.0.0/24 via 172.21.0.3 dev eth2

# Abilita il Masquerading
iptables -t nat -A POSTROUTING -o eth2 -j MASQUERADE
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE

# Regole per clonare il traffico in arrivo da 172.20.0.2
tc qdisc add dev eth0 ingress
tc filter add dev eth0 parent ffff: protocol ip u32 match ip src 172.20.0.2 action mirred egress mirror dev eth1

# Mantieni il container in esecuzione
exec "$@"
