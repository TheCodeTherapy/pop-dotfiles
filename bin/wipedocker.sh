#!/bin/bash

###
### Author: Marco Gomez / https://mgz.me/
###

read -p "Are you ABSOLUTELY SURE that you want to wipe all the docker containers in your system? [y/N] " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    exit 0
fi
docker stop $(docker ps -a -q)
docker rm -f $(docker ps -a -q)
docker rmi -f $(docker images -a -q)
docker images purge
sudo rm -rf database
sudo rm -rf data-node
docker image prune
sudo systemctl stop docker && sudo rm -rf /var/lib/docker && sudo systemctl start docker

