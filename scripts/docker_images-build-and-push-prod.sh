#!/bin/bash

# usage: ./path_to_this_script env
#         where env is: prod, test or dev

# before running, first authenticate and configure gcloud:
# gcloud auth login
# gcloud auth configure-docker europe-north1-docker.pkg.dev
# gcloud config set project polis-kokeilu-prod

cd ../polis/
docker build . -f file-server/Dockerfile -t europe-north1-docker.pkg.dev/polis-kokeilu-prod/polis-kokeilu-prod/polis-file-server:$1

cd ./math/
docker build . -t europe-north1-docker.pkg.dev/polis-kokeilu-prod/polis-kokeilu-prod/polis-math:$1

cd ../server/
docker build . -t europe-north1-docker.pkg.dev/polis-kokeilu-prod/polis-kokeilu-prod/polis-server:$1

# push images
docker push europe-north1-docker.pkg.dev/polis-kokeilu-prod/polis-kokeilu-prod/polis-file-server:$1
docker push europe-north1-docker.pkg.dev/polis-kokeilu-prod/polis-kokeilu-prod/polis-math:$1
docker push europe-north1-docker.pkg.dev/polis-kokeilu-prod/polis-kokeilu-prod/polis-server:$1