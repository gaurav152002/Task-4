#!/bin/bash

# Update package lists
apt-get update -y

# Install docekr
apt-get install docker.io -y

# start docker service
systemctl start docker
systemctl enable docker

# allowing the user to run docker commands without sudo
usermod -aG docker ubuntu

#run string app in docker container
docker run -d -p 1337:1337 --name strapi strapi/strapi