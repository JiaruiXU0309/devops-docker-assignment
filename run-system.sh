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
    -v ./Chinook.db:/app/Chinook.db:ro \
    -e SQLITE_FILE=/app/Chinook.db \
    -e DATABASE_URL=postgres://hanna:hanna@chinook-db:5432/chinook \
    music-agent-seeder:latest

docker run -d --name mcp-gateway \
    --label assignment=music-agent \
    --network music-agent-network \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v ./mcp_config.yaml:/mcp_config.yaml:ro \
    -v ./mcp_secret.env:/run/secrets/database-url:ro \
    docker/mcp-gateway:latest \
    --transport=sse \
    --secrets=/run/secrets/database-url \
    --allow-unauthenticated \
    --servers=cockroachdb \
    --tools=execute_query \
    --config=/mcp_config.yaml
