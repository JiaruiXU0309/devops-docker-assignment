#!/bin/sh

set -e

docker network create --label assignment=music-agent music-agent-network

docker build --label assignment=music-agent --target seeder -t music-agent-seeder:latest .

docker build --label assignment=music-agent --target agent -t music-agent-agent:latest .

docker run -d --name chinook-db \
    --label assignment=music-agent \
    --network music-agent-network \
    -e POSTGRES_USER=hanna \
    -e POSTGRES_PASSWORD=hanna \
    -e POSTGRES_DB=chinook \
    postgres:latest










docker build -t assignment-demo:1.0 ./sample-app/

docker run -d --name assignment \
       -p 3000:80 \
    assignment-demo:1.0

sleep 10
echo "Container started"
