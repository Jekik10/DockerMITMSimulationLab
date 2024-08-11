#!/bin/bash

# Executes the playbook if it's not empty
if [ -s /.ansible/server-config.yml ]; then \
  ansible-playbook /.ansible/server-config.yml; \
fi

# Configure static route to the client
ip route add 172.20.0.0/24 via 172.21.0.3

# Keeps the container running
exec "$@"
