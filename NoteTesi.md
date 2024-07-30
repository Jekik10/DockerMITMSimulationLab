LINKS: 
duplicate iptables traffic to another ip
https://superuser.com/questions/853077/iptables-duplicate-traffic-to-another-ip

---------------------------------------------------------------------------------------------------------
NOTA: 
per clonare il traffico nel router verso l'ids, ho bisogno del kernel module xt_TEE.
nel os del router (debian:stable-slim) il modulo kernel xt_TEE non è presente.
Possibili soluzioni: 
1) utilizzare un os piu completo ma anche più pesante (quale ubuntu)
2) ricompilare il kernel di una immagine specifica di debian, inserendo il module xt_TEE
anche se così facendo si perde la aggiornabilità del sistema nel tempo (si dovrebbe ricompilare 
il kernel a ogni cambio di versione di debian)
3) abilitare il modulo xt_TEE nel sistema ospitante sfruttando la possibilità di docker di 
utilizzare parti del kernel ospitante. questo potrebbe essere fatto nello script di avvio del container, ma
richiederebbe i diritti di root:

possibile script
#!/bin/bash
sudo modprobe ipt_TEE #o xt_TEE
docker compose up --build -d 

----------------------------------------------------------------------------------------------------------

DOMANDE: 

è necessaria qualche configurazione particolare per suricata? 
attualmente il file di configurazione è completamente stock (non è settata neanche la HOME_NET che dovrebbe essere 172.21.0.0/24) che in realtà dovrei mettere per "astrarre" la scrittura delle regole.

è un problema il dover lanciare lo script run con i privilegi di root?
attualmente è necessario per attivare il modulo kernel xt_TEE nella macchina host per dare la possibilità al
router di sfruttarlo e clonare il traffico verso l'ids

va bene come ho fatto l'instradamento dei pacchetti? 
probabilmente ci sono modi migliori, ma visto che allo scopo di testare le regole suricata bastano un 
client e un server, ho scritto le regole sul router nella maniera più basilare possibile, inoltrando 
semplicemente tutto il traffico dall'ip del client verso l'ip del server



