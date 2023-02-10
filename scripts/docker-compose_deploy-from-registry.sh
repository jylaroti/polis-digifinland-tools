#!/bin/bash
# usage: ./path_to_this_script env
#         where env is: test or dev

# build and run
DOCKER_ENV=$1 docker compose -f docker-compose-digifinland-from-registry.yml up -d

# list running containers
docker ps

