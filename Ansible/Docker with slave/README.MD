First w need to create a custom Network in docker because the default network using DHCP and we want the IP not to change

Create a custom network named "andible_network" with a subnet of 172.18.0.0/16 and a gateway of 172.18.0.1
```docker network create --subnet=172.18.0.0/16 --gateway=172.18.0.1 ansible_network```

To make sure it worked we can view all networks on docker
```docker network ls ```

Start a Docker container named "slave" based on the Ubuntu image and attach it to the custom network
```docker run -it -P --name slave --network ansible_network --ip 172.18.0.2 ubuntu```

Update and upgrade the system packages
```apt-get update -y && apt-get upgrade -y```

Install required packages: Python 3, OpenSSH server, Vim, and systemd
```apt install -y python3 openssh-server vim net-tools systemd ```

Configure SSH to allow root login and public key authentication *you can edit by VIM this is just easy command
```sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config```
```sed -i 's/#PubkeyAuthentication yes/PubkeyAuthentication yes/' /etc/ssh/sshd_config```

Set a password for the root user to enable SSH login
```sudo passwd root```

Check the status of running services, if SSH is off (-) then start it. 
```service --status-all```
```service ssh restart```

To make sure SSH service start after conatiner reatart. 
```systemctl start ssh ```



Start a Docker container named "master" based on the Ubuntu image and attach it to the custom network
```docker run -it -P --name master --network ansible_network --ip 172.18.0.3 ubuntu```

Update and upgrade the system packages
```apt-get update -y && apt-get upgrade -y```

Install Ansible and Vim
```sudo apt install -y vim ansible```

Create a directory for Ansible configuration files (sometimes ansible wont create it ) 
```sudo mkdir -p /etc/ansible```

Add the IP address of the slave node to the master's inventory hosts file
```echo "<IP>" | sudo tee -a /etc/ansible/hosts```


Create ssh key (just continue Enter all time)
```ssh-keygen```

Copy my Pub key to slave ssh file of known IP
```ssh-copy-id -i ./.ssh/id_rsa.pub root@<ip>```

Check if slave connected to master with ping
```ansible -m ping all```