#!/bin/bash

set -e

echo "Starting ValidateService hook..."

# Wait for the application to be ready
max_attempts=30
attempt=1

while [ $attempt -le $max_attempts ]; do
    echo "Health check attempt $attempt/$max_attempts"
    
    # Check if the container is running
    if ! docker ps | grep -q fastapi-app; then
        echo "ERROR: Container is not running"
        exit 1
    fi
    
    # Check if the application is responding (health check)
    if curl -f -s http://localhost:80/health > /dev/null 2>&1; then
        echo "Health check passed - application is responding"
        echo "ValidateService hook completed successfully"
        exit 0
    elif curl -f -s http://localhost:80/ > /dev/null 2>&1; then
        echo "Basic connectivity check passed"
        echo "ValidateService hook completed successfully"
        exit 0
    else
        echo "Health check failed, waiting 10 seconds before retry..."
        sleep 10
        attempt=$((attempt + 1))
    fi
done

echo "ERROR: Health check failed after $max_attempts attempts"
echo "Container logs:"
docker logs fastapi-app
exit 1
