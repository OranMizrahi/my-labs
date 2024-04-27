



We update all the repo and install dependcie for ansible
```
sudo apt update
sudo apt install software-properties-common
```

We will now add ansible to ur Personal Package Archive (PPA) we do it to ensure we installing the latest stable version of Ansible.
```
sudo apt-add-repository --yes --update ppa:ansible/ansible
sudo apt install ansible
```