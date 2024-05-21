This tutorial help you start ansible master with slaves
You can reveal the questions or trying without. 

### Create Custom Docker Network
<details>
  <summary><i>reveal answer</i></summary>
  
  ```
  docker network create --subnet=172.18.0.0/16 --gateway=172.18.0.1 ansible_network
  ```
</details>

### View All Docker Networks
<details>
  <summary><i>reveal answer</i></summary>
  
  ```
  docker network ls
  ```
</details>

### Start Docker Container Named "slave" Attached to Custom Network
<details>
  <summary><i>reveal answer</i></summary>
  
  ```
  docker run -it -P --name slave --network ansible_network --ip 172.18.0.2 ubuntu
  ```
</details>

### Update and Upgrade System Packages in "slave" Container
<details>
  <summary><i>reveal answer</i></summary>
  
  ```
  apt-get update -y && apt-get upgrade -y
  ```
</details>

### Install Required Packages in "slave" Container
<details>
  <summary><i>reveal answer</i></summary>
  
  ```
  apt install -y python3 openssh-server vim net-tools systemd
  ```
</details>

### Configure SSH in "slave" Container
<details>
  <summary><i>reveal answer</i></summary>
  
  ```
  sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
  sed -i 's/#PubkeyAuthentication yes/PubkeyAuthentication yes/' /etc/ssh/sshd_config
  ```
</details>

### Set Password for Root User in "slave" Container
<details>
  <summary><i>reveal answer</i></summary>
  
  ```
  passwd root
  ```
</details>

### Check Status of Running Services in "slave" Container
<details>
  <summary><i>reveal answer</i></summary>
  
  ```
  service --status-all
  ```
</details>

### Restart SSH Service in "slave" Container
<details>
  <summary><i>reveal answer</i></summary>
  
  ```
  service ssh restart
  ```
</details>

### Start Docker Container Named "master" Attached to Custom Network
<details>
  <summary><i>reveal answer</i></summary>
  
  ```
  docker run -it -P --name master --network ansible_network --ip 172.18.0.3 ubuntu
  ```
</details>

### Update and Upgrade System Packages in "master" Container
<details>
  <summary><i>reveal answer</i></summary>
  
  ```
  apt-get update -y && apt-get upgrade -y
  ```
</details>

### Install Ansible and Vim in "master" Container
<details>
  <summary><i>reveal answer</i></summary>
  
  ```
  sudo apt install -y vim ansible
  ```
</details>

### Create Directory for Ansible Configuration Files in "master" Container
<details>
  <summary><i>reveal answer</i></summary>
  
  ```
  sudo mkdir -p /etc/ansible
  ```
</details>

### Add Slave Node IP Address to Master's Inventory Hosts File
<details>
  <summary><i>reveal answer</i></summary>
  
  ```
  echo "<IP>" | sudo tee -a /etc/ansible/hosts
  ```
</details>



### Create SSH Key in "master" Container
<details>
  <summary><i>reveal answer</i></summary>
  
  ```
  ssh-keygen
  ```
</details>

### Copy Public Key to Slave SSH File of Known IP
<details>
  <summary><i>reveal answer</i></summary>
  
  ```
  ssh-copy-id -i ./.ssh/id_rsa.pub root@<ip>
  ```
</details>

### Check if Slave Connected to Master with Ping
<details>
  <summary><i>reveal answer</i></summary>
  
  ```
  ansible -m ping all
  ```
</details>

If you got into the end you did a great job, but we devops like all to be as IaC, oganizing this into a docker-compose.yaml will provide a more efficient and reproducible setup.