# Docker MITM Simulation Lab for and Intrusion Detection System. 
## Objective 
Automate the creation of a testing environment for `Suricata` rules in IDS mode using Docker, with customizable clients and servers through the use of `Ansible`

## Launch
Run the `run.sh` script, passing the file containing the Suricata rules as a parameter to start the simulation lab.
```
./run.sh path-to-suricata-rules
```

You can provide customized Ansible playbooks for clients and servers as optional parameters. 
The names of the playbooks are arbitrary, but make sure to use the `.yml` extension. 
To write the playbooks, carefully read these [Notes for using custom Ansible playbooks](https://github.com/Jekik10/DockerMITMSimulationLab/edit/main/README.md#notes-for-using-custom-ansible-playbooks).

### Example usage:
```
./run rules client-playbook.yml server-playbook.yml
```
It is not necessary to provide both playbooks
```
./run rules client-playbook.yml
```
however, if you want to omit **only** the client playbook, specify `none`:
```
./run rules none server-playbook.yml
```

## Architecture

The router mirrors incoming traffic on `eth0` towards the IDS using [tc](https://man7.org/linux/man-pages/man8/tc.8.html) with the following rules:
```
tc qdisc add dev eth0 ingress
tc filter add dev eth0 parent ffff: protocol ip u32 match ip src 172.20.0.2 action mirred egress mirror dev eth1
```
![MITMSimulationLab](https://github.com/user-attachments/assets/1a25355c-b1e1-4801-a5b0-1924e6c1b787)


## Notes for using custom Ansible playbooks
The `ansible_configs` directory is mounted at container startup as a docker volume, in both the client and server containers, at the path `/ansible_configs`.

## Examples
