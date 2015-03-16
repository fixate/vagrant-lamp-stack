#!/usr/bin/env bash

if [[ $EUID -ne 0  ]]; then
  echo "This script must be run as root"
  exit 1
fi

which ansible-playbook > /dev/null 2>/dev/null
if [[ $? -ne 0 ]]; then
  apt-add-repository -y ppa:ansible/ansible
  apt-get update
  apt-get install ansible
else
  echo "----> Ansible already installed!"
  exit 0
fi
