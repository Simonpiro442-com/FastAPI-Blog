#!/bin/bash

set -e

echo "Starting BeforeInstall hook..."

# Create application directory if it doesn't exist
sudo mkdir -p /home/ec2-user/fastapi-app
sudo chown ec2-user:ec2-user /home/ec2-user/fastapi-app

# Install Docker if not already installed
if ! command -v docker &> /dev/null; then
    echo "Installing Docker..."
    sudo yum update -y
    sudo yum install -y docker
    sudo service docker start
    sudo usermod -a -G docker ec2-user
fi

# Ensure Docker is running
sudo service docker start || true

# Login to ECR (this will be handled by the deployment process)
echo "BeforeInstall hook completed successfully"
