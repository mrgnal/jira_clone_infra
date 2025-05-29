#!/bin/bash

#Install packages
sudo apt update && sudo apt upgrade -y
sudo apt install -y ansible-core sshpass

ansible-galaxy collection install community.postgres

# Generate SSH key
sudo -u vagrant ssh-keygen -t rsa -N "" -f /home/vagrant/.ssh/id_rsa

# IP_FILE="./node_ips.txt"
# if [ -f "$IP_FILE" ]; then
#   mapfile -t TARGET_IPS < "$IP_FILE"
# else
#   echo "No IP list found."
#   exit 1
# fi

#Share keys
# for ip in "${TARGET_IPS[@]}"; do
#   echo "Copying SSH key to $ip..."
#   sudo -u vagrant sshpass -p 'vagrant' ssh-copy-id -o StrictHostKeyChecking=no vagrant@$ip
# done

sudo -u vagrant sshpass -p 'vagrant' ssh-copy-id -o StrictHostKeyChecking=no vagrant@192.168.1.11
sudo -u vagrant sshpass -p 'vagrant' ssh-copy-id -o StrictHostKeyChecking=no vagrant@192.168.1.12
sudo -u vagrant sshpass -p 'vagrant' ssh-copy-id -o StrictHostKeyChecking=no vagrant@192.168.1.13
sudo -u vagrant sshpass -p 'vagrant' ssh-copy-id -o StrictHostKeyChecking=no vagrant@192.168.1.14
sudo -u vagrant sshpass -p 'vagrant' ssh-copy-id -o StrictHostKeyChecking=no vagrant@192.168.1.15