#!/bin/bash

# Executes the playbook if it's not empty
if [ -s /.ansible/client-config.yml ]; then
  ansible-playbook /.ansible/client-config.yml
fi

# Configure static route to the server
ip route add 172.21.0.0/24 via 172.20.0.3

# Keeps the container running
exec "$@"
