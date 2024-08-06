#!/bin/bash

# Fetch the instance IP from Terraform output
NODE2_IP=$(terraform output -raw node2_ip)

# Update the Ansible hosts file on the controller node
ssh -t -i /home/ubuntu/terraform/assignment/devops.pem ubuntu@35.154.61.143 <<EOF
sudo bash -c 'echo "[node2]" >> /etc/ansible/hosts'
sudo bash -c 'echo "$NODE2_IP ansible_user=ubuntu ansible_ssh_private_key_file=/etc/ansible/devops.pem" >> /etc/ansible/hosts'
EOF



