#!/bin/bash

# Checks that the first parameter is an existing file
if ! [ -f "$1" ]; then
    echo "File $1 does not exist."
    echo 'Required parameters: suricata-rules (Optional: client-config.yml/"none" server-config.yml)'
    exit 1
fi

# Checks that the optional file, if present, is a .yml file or $2="none"
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

    # Copies the file to client-config.yml
    cp $2 client-config.yml

else
    # Creates an empty client-config.yml file
    touch client-config.yml    
fi

# Checks that the optional file, if present, is a .yml file
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

    # Copies the file to server-config.yml
    cp $3 server-config.yml

else
    # Creates an empty server-config.yml file
    touch server-config.yml    
fi

# Copies the file to suricata.rules
cp $1 suricata.rules

# Runs the docker compose
docker compose up --build -d

# Removes the files
rm suricata.rules
rm client-config.yml
rm server-config.yml
