#!/bin/bash

#controlla che il primo parametro sia un file esistente
if ! [ -f "$1" ]; then
    echo "File $1 does not exist."
    exit 1
fi
#copia il contenuto del file in suricata.rules
cp $1 suricata.rules

# sudo modprobe ipt_TEE # oppure xt_TEE
docker compose up --build -d

rm suricata.rules