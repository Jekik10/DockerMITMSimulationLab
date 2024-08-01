#!/bin/bash

#controlla che il primo parametro sia un file esistente
if ! [ -f "$1" ]; then
    echo "File $1 does not exist."
    echo 'Required parameters: suricata-rules (Optional: client-config.yml/"none" server-config.yml)'
    exit 1
fi

#controlla che il file opzionale, se presente, sia un file .yml oppure $2="none"
if [ -n "$2" ] && [ "$2" != "none" ]; then
    if ! [ -f "$2" ]; then
        echo "File $2 does not exist."
        echo 'Required parameters: suricata-rules (Optional: client-config.yml/"none" server-config.yml)'
        exit 1
    fi
    if [[ $2 != *.yml ]]; then
        echo "File $2 is not a .yml file."
        echo 'Required parameters: suricata-rules (Optional: client-config.yml/"none" server-config.yml)'
        exit 1
    fi

    #copia il file in server-config.yml
    cp $2 client-config.yml

else
    touch client-config.yml    
fi

#controlla che il file opzionale, se presente, sia un file .yml
if [ -n "$3" ]; then
    if ! [ -f "$3" ]; then
        echo "File $3 does not exist."
        echo 'Required parameters: suricata-rules (Optional: client-config.yml/"none" server-config.yml)'
        exit 1
    fi
    if [[ $3 != *.yml ]]; then
        echo "File $3 is not a .yml file."
        echo 'Required parameters: suricata-rules (Optional: client-config.yml/"none" server-config.yml)'
        exit 1
    fi

    #copia il file in server-config.yml
    cp $3 server-config.yml

else
    touch server-config.yml    
fi

#copia il file in suricata.rules
cp $1 suricata.rules

docker compose up --build -d
rm suricata.rules
rm client-config.yml
rm server-config.yml
