#!/bin/bash

set -e

echo "Starting ApplicationStart hook..."

# Navigate to application directory
cd /home/ec2-user/fastapi-app

# Source environment variables from image_info file
if [ -f "image_info" ]; then
    source image_info
    echo "Loaded environment variables from image_info"
else
    echo "ERROR: image_info file not found"
    exit 1
fi

# Start the FastAPI application using Docker
if [ -n "$IMAGE_URI" ]; then
    echo "Starting FastAPI application with image: $IMAGE_URI"
    
    # Run the Docker container
    docker run -d \
        --name fastapi-app \
        -p 80:8000 \
        --restart unless-stopped \
        $IMAGE_URI
    
    echo "FastAPI application started successfully"
    
    # Wait a moment for the container to start
    sleep 5
    
    # Check if container is running
    if docker ps | grep -q fastapi-app; then
        echo "Container is running"
    else
        echo "ERROR: Container failed to start"
        docker logs fastapi-app
        exit 1
    fi
else
    echo "ERROR: IMAGE_URI environment variable not set"
    exit 1
fi

echo "ApplicationStart hook completed successfully"
