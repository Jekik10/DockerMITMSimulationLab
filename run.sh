#!/bin/bash

#controlla che il primo parametro sia un file esistente
if ! [ -f "$1" ]; then
    echo "File $1 does not exist."
    echo "Required parameter: path-to-rules client-config server-config"
    exit 1
fi

#copia il contenuto del file in suricata.rules
cp $1 suricata.rules

docker compose up --build -d
rm suricata.rules