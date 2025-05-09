#!/bin/bash

# Exit on any error
set -e

# Update existing list of packages
echo "Updating package list..."
sudo apt-get update

# Install required packages to allow apt to use a repository over HTTPS
echo "Installing prerequisites..."
sudo apt-get install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

# Add Docker’s official GPG key
echo "Adding Docker GPG key..."
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

# Set up the stable Docker repository
echo "Adding Docker repository..."
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Update package list again after adding Docker repo
sudo apt-get update

# Install Docker Engine, CLI, and containerd
echo "Installing Docker Engine..."
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Enable Docker to start on boot
sudo systemctl enable docker

# Add current user to docker group (you may need to log out/in after this)
sudo usermod -aG docker $USER

echo "Docker installation completed successfully!"
echo "You may need to log out and log back in for group changes to take effect."
