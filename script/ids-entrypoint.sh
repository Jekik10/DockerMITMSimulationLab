#!/bin/sh

# Configure Suricata to sniff traffic on eth0
suricata -i eth0 -l /var/log/suricata --init-errors-fatal
# suricata -i eth0 -c /etc/suricata/suricata.yaml -l /var/log/suricata --init-errors-fatal

# Keeps the container running
exec "$@"
