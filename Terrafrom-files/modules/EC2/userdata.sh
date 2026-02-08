#!/bin/bash
set -eux
exec > /var/log/user-data.log 2>&1

# Update system
apt-get update -y

# Create 2GB swap (VERY IMPORTANT)
fallocate -l 2G /swapfile
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile
echo '/swapfile none swap sw 0 0' >> /etc/fstab

# Install Node.js 20
curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
apt-get install -y nodejs

# Install docekr
apt-get install docker.io -y

# start docker service
systemctl start docker
systemctl enable docker

# allowing the user to run docker commands without sudo
usermod -aG docker ubuntu

docker pull gauravjith/strapi:1.0

docker run -d \
  --name strapi \
  -p 1337:1337 \
  --restart always \
  -e APP_KEYS="key1,key2,key3,key4" \
  -e ADMIN_JWT_SECRET="adminjwtsecret" \
  -e API_TOKEN_SALT="apitokensalt" \
  -e JWT_SECRET="userjwtsecret" \
  gauravjith/strapi:1.0



