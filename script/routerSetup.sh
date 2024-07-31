#!/bin/sh

# Abilita l'inoltro IP
echo 1 > /proc/sys/net/ipv4/ip_forward 

# Regole di instradamento client to server
iptables -t nat -A PREROUTING -d 172.20.0.3 -j DNAT --to-destination 172.21.0.2
iptables -t nat -A POSTROUTING -s 172.20.0.0/24 -d 172.21.0.2 -j MASQUERADE

# Regole di instradamento server to client
iptables -t nat -A PREROUTING -d 172.21.0.3 -j DNAT --to-destination 172.20.0.2
iptables -t nat -A POSTROUTING -s 172.21.0.0/24 -d 172.20.0.2 -j MASQUERADE

# Regole per clonare il traffico in arrivo da 172.20.0.2
tc qdisc add dev eth0 ingress
tc filter add dev eth0 parent ffff: protocol ip u32 match ip src 172.20.0.2 action mirred egress mirror dev eth1

# Aggiungere regole traffic control per "pulire" il traffico verso l'ids  



# Mantieni il container in esecuzione
exec "$@"
