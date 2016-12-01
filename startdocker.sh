#!/bin/bash
dev_docker_file="docker-compose.yml"

export localhost_ip="$(ifconfig en0 inet | grep "inet " | awk -F'[: ]+' '{ print $2 }')"

echo "localhost: $localhost_ip"

docker-compose -f $dev_docker_file build
docker-compose -f $dev_docker_file run wrk bash
