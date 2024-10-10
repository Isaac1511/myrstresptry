#!/bin/bash

cd '~/OneDrive/Desktop/Lab ish/My Lab Ish/Projects/AnkSolutions Inc/myrstresptry'

terraform init
terraform fmt anksol_main.tf anksol_var.tf

terraform apply -auto-approve