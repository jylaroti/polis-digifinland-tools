#!/bin/bash
# usage: ./path_to_this_script env
#         where env is: test or dev

# stop containers
cd ../polis/
DOCKER_ENV=$1 docker compose -f docker-compose-digifinland.yml down

# list running containers
docker ps
