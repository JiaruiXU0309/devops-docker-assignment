#!/bin/sh

#clean containers
container_ids=$(docker ps -a -q --filter label=assignment=music-agent)
if [ -n "$container_ids" ]; then
    echo "Stopping and removing assignment containers..."
    docker stop $container_ids
    docker rm -v $container_ids
else
    echo "No assignment containers found."
fi

#clean networks
network_id=$(docker network ls -q --filter label=assignment=music-agent)
if [ -n "$network_id" ]; then
    echo "Removing assignment network..."
    docker network rm $network_id
else
    echo "No assignment networks found."
fi

#clean images
image_ids=$(docker image ls -q --filter label=assignment=music-agent)
if [ -n "$image_ids" ]; then
    echo "Removing assignment images..."
    docker image rm $image_ids
else
    echo "No assignment images found."
fi