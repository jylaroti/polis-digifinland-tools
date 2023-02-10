#!/bin/bash
# usage: ./path_to_this_script env
#         where env is: test or dev


cd ../polis/

# build and run
DOCKER_ENV=$1 docker compose -f docker-compose-digifinland.yml up -d --build 

# list running containers
docker ps
