#!/bin/bash

if [ -s /.ansible/client-config.yml ]; then
  ansible-playbook /.ansible/client-config.yml
fi

# Configura la rotta statica per raggiungere il server
ip route add 172.21.0.0/24 via 172.20.0.3

# Esegui il comando originale del container
exec "$@"
