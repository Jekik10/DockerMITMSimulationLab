#!/bin/sh

# Test clone icmp traffic
# tcpdump -i eth0 icmp > /tmp/icmp.pcap

# Regola suricata per sniffare il traffico su eth0
# suricata -i eth0 -c /etc/suricata/suricata.yaml -l /var/log/suricata --init-errors-fatal
suricata -i eth0 -l /var/log/suricata --init-errors-fatal


# Mantiene il container in esecuzione
exec "$@"
