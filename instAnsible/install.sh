#!/bin/bash

if [[ $EUID -ne 0 ]]; then
	echo "This script must run as root or sudo."
	exit 1
fi

echo "Installing Ansible."
apt-add-repository ppa:ansible/ansible
apt update
apt install -y ansible
echo "Done."

echo "Creating basic configuration."
MAINHOST="/etc/ansible/hosts"
touch $MAINHOST
echo "[servers]" > $MAINHOST
echo "server1 ansible_host=10.20.30.10" >> $MAINHOST
echo "" >> $MAINHOST
echo "[all:vars]" >> $MAINHOST
echo "ansible_python_interpreter=/usr/bin/python3" >> $MAINHOST
echo "Done."
ansible-inventory --list -y

if test -f "/$USER/.ssh/id_ed25519"; then
	echo "SSH key for $USER found."
else
	ssh-keygen -t ed25519 -a 14400 -N "" -f /$USER/.ssh/id_ed25519
	echo "SSH key for $USER created."
fi


