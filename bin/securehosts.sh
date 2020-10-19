#!/bin/bash
HOSTSBACKUP=/etc/hosts.bak
if [ ! -f "$HOSTSBACKUP" ]; then
	sudo cp /etc/hosts /etc/hosts.bak
fi
sudo wget https://hosts.ubuntu101.co.za/hosts -O /etc/hosts
