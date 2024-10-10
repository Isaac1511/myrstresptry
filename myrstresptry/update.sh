#!/bin/bash

hostname
pwd 

# Install Update and Upgrade packages.
sudo apt update
sudo apt upgrade 

# Install Python, Python Manager.
sudo apt install python3
sudo apt install python3-pip

# Install Ansible.
sudo apt install ansible -y 
sudo ansible --version


cd ~
hostname 
pwd