#!/bin/bash

# Configura la rotta statica per raggiungere il client
ip route add 172.20.0.0/24 via 172.21.0.3

# Esegui il comando originale del container
exec "$@"
