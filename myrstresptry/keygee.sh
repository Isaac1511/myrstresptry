#!/bin/bash

# keygen & copyid script

# Input remote user IPs
read -p "please enter remote username: " Uname
read -p "Please enter ipaddress: " IP



# copy key to host(s)
ssh-copy-id -i ~/.ssh/id_rsa.pub $Uname@$IP

# test ssh connection to host(s)
ssh $Uname@$IP