#!/bin/sh
container_ids=$(docker ps -a -q --filter label=assignment=music-agent)

if [ -n "$container_ids" ]; then
    docker stop $container_ids
    docker rm -v $container_ids
fi

network_id=$(docker network ls -q --filter label=assignment=music-agent)

if [ -n "$network_id" ]; then
    docker network rm $network_id
fi

image_ids=$(docker image ls -q --filter label=assignment=music-agent)

if [ -n "$image_ids" ]; then
    docker image rm $image_ids
fi