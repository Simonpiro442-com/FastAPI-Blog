#!/bin/bash

set -e

echo "Starting AfterInstall hook..."

cd /home/ec2-user/fastapi-app

# Source environment variables from image_info file
if [ -f "image_info" ]; then
    source image_info
    echo "Loaded environment variables from image_info"
else
    echo "ERROR: image_info file not found"
    exit 1
fi

# Pull the latest Docker image from ECR
if [ -n "$IMAGE_URI" ]; then
    echo "Pulling Docker image: $IMAGE_URI"
    
    # Login to ECR
    aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $ECR_REGISTRY
    
    # Pull the image
    docker pull $IMAGE_URI
else
    echo "ERROR: IMAGE_URI environment variable not set"
    exit 1
fi

# Stop and remove existing container if it exists
docker stop fastapi-app || true
docker rm fastapi-app || true

echo "AfterInstall hook completed successfully"
