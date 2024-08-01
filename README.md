# Docker MITM Simulation Lab for and Intrusion Detection System. 
## Objective 
Automate the creation of a testing environment for [Suricata](https://suricata.io/) rules in IDS mode using Docker, with customizable clients and servers through the use of [Ansible](https://www.ansible.com/)

## Launch
Run the `run.sh` script, passing the file containing the Suricata rules as a parameter to start the simulation lab.
```
./run.sh path-to-suricata-rules
```

You can provide customized Ansible playbooks for clients and servers as optional parameters. 
The names of the playbooks are arbitrary, but make sure to use the `.yml` extension. 
> [!Warning]
> To write the playbooks, carefully read these [Notes for using custom Ansible playbooks](https://github.com/Jekik10/DockerMITMSimulationLab#notes-for-using-custom-ansible-playbooks).

### Example usage:
```
./run.sh rules client-playbook.yml server-playbook.yml
```
> [!IMPORTANT]
>It is not necessary to provide both playbooks
>```
>./run.sh rules client-playbook.yml
>```
>however, if you want to omit **only** the client playbook, specify `none`:
>```
>./run.sh rules none server-playbook.yml
>```

>[!NOTE]
>Suricata logs directory can be found in the IDS container at `/var/log/suricata`

## Architecture

The router mirrors incoming traffic on `eth0`, towards the IDS, using [tc](https://man7.org/linux/man-pages/man8/tc.8.html) with the following rules:
```
tc qdisc add dev eth0 ingress
tc filter add dev eth0 parent ffff: protocol ip u32 match ip src 172.20.0.2 action mirred egress mirror dev eth1
```
![MITMSimulationLab](https://github.com/user-attachments/assets/1a25355c-b1e1-4801-a5b0-1924e6c1b787)


## Notes for using custom Ansible playbooks
The `ansible_configs` directory is mounted at container startup as a Docker volume, in both the client and server containers, at the path `/ansible_configs`.

So, if your playbooks need any other files to work as intended, copy them into this directory and refer to the correct path in the playbook.

Also, remember that the playbook is executed directly inside the container
```yaml
# Playbook code
  hosts: localhost
  connection: local
```
and files inside the volume may need the correct privileges
```yaml
# Playbook code
  become: yes
  tasks:
    - name: Set x privileges for test.sh
      ansible.builtin.command: chmod +x /ansible_configs/test.sh
```
> [!NOTE]
> Empty playbooks will not be executed and won't cause any errors or warnings.

## Examples
### Ansible
An example script is already located at `/ansible_configs/example.sh`. It simply creates a file with some text inside `/tmp`.

A playbook to execute that script could look like:
```yaml
---
- name: Run the test.sh script from the Docker volume
  hosts: localhost
  connection: local
  become: yes
  tasks:
    - name: Set x privileges for test.sh
      ansible.builtin.command: chmod +x /ansible_configs/test.sh

    - name: Run test.sh
      ansible.builtin.command: /ansible_configs/test.sh

```
### Suricata
The rule file should follow the Suricata rules syntax. An example of a rule file that matches both TCP and UDP packets is:
```
alert tcp any any -> any any (msg:"TCP Echo Request Detected"; sid:1000001; rev:1;)
alert udp any any -> any any (msg:"UDP Echo Request Detected"; sid:1000002; rev:1;)
```
