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

until docker exec chinook-db pg_isready; do
    echo "Waiting for PostgreSQL..."
    sleep 2
done

docker run --name seeder \
    --label assignment=music-agent \
    --network music-agent-network \
    -v "$PWD/Chinook.db:/app/Chinook.db:ro" \
    -e SQLITE_FILE=/app/Chinook.db \
    -e DATABASE_URL=postgres://hanna:hanna@chinook-db:5432/chinook \
    music-agent-seeder:latest

