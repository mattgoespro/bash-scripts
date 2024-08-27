#!/bin/bash

# Add Docker's official GPG key
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
echo "Added Docker GPG keyring to apt."

# shellcheck source=/dev/null
# Add the repository to Apt sources
echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" |
    sudo tee /etc/apt/sources.list.d/docker.list >/dev/null
echo "Added Docker repository to Apt sources."

sudo apt-get update

# Install Docker packages
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
echo "Installed Docker."

# Add the current user to the Docker group
sudo groupadd docker
echo "Created Docker group."
sudo usermod -aG docker "$USER"
echo "Added user to Docker group."
newgrp docker
echo "Activated group changes."

# Configure Docker to start on boot
sudo systemctl enable docker.service
sudo systemctl enable containerd.service
echo "Configured Docker to start on boot."

# Verify Docker installation
docker --version
echo "Docker installation verified."

echo "Docker installation complete."
exit 0
