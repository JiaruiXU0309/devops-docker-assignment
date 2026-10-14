#!/bin/sh

set -e

docker network create --label assignment=music-agent music-agent-network

docker build --label assignment=music-agent --target seeder -t music-agent-seeder:latest .












docker build -t assignment-demo:1.0 ./sample-app/

docker run -d --name assignment \
       -p 3000:80 \
    assignment-demo:1.0

sleep 10
echo "Container started"
