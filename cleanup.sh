#!/bin/sh
# TODO
container_ids=$(docker ps -a -q --filter label=assignment=music-agent)

if [ -n "$container_ids" ]; then
    docker stop $containers_id
    docker rm $containers_id
fi