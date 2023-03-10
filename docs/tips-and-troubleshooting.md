
# Database

Dump data:
```
pg_dump -Fc -h 127.0.0.1 -U polistestu -W polistestdb --no-owner > polis-local-dump-no-owner-20221213.dump
```

Overwrite data:
```
pg_restore --clean -h 127.0.0.1 -U polistestu -W -d polistestdb polis-local-dump-no-owner-20221213.dump
```

# Minikube k8s

## Authenticate with GCP to pull images before deploying

```
gcloud auth application-default login
minikube addons enable gcp-auth
```
If authentication stop working after some time, try refreshing:
```
minikube addons enable gcp-auth --refresh
```

## Switch to minikube context
See available contexts and Switch to local minikube context:
```
kubectl config get-contexts
kubectl config use-context minikube
```

## Access Kubernetes dashboard
```
minikube dashboard
```

## Reset addons and all deployments
If ingress addon (or other addon) gets stuck pending state, try starting over. It's easier than patching addon images etc.
```
minikube delete --all --purge
```

# GKE k8s

## Build and push images to artifact registry:

Script takes registry repository location and image tag as arguments.

Example:
```
./scripts/docker_images-build-and-push.sh example.com/project/repository tag-name
```


Production:
```
./scripts/docker_images-build-and-push.sh europe-north1-docker.pkg.dev/polis-kokeilu-prod/polis-kokeilu-prod prod
```

Test:
```
./scripts/docker_images-build-and-push.sh europe-north1-docker.pkg.dev/polis-kokeilu/polis-kokeilu-test test
```


## Set server and file-server autoscaling (HPA) manually
```
kubectl autoscale deployment polis-server --cpu-percent=50 --min=2 --max=10
kubectl autoscale deployment polis-file-server --cpu-percent=25 --min=2 --max=4
```

## Display logs from selected apps

```
kubectl logs -l app=polis-math --timestamps=true --all-containers=true -f --prefix=true
```
```
kubectl logs -l app=polis-server --timestamps=true --all-containers=true -f --prefix=true
```

## Deploy to GKE 

First login (or activate service account) and select correct cluster - test:
```
gcloud auth login
gcloud container clusters get-credentials polis-kokeilu-test-cluster --zone europe-north1-c
```
Prod:
```
gcloud auth login
gcloud container clusters get-credentials polis-kokeilu-prod-cluster --zone europe-north1-c
```


When deploying from local, create SSH tunnel to cluster endpoint through test VM (for test cluster):
```
gcloud compute ssh --zone "europe-north1-a" "[username]@polis-test"  --project "polis-kokeilu" --tunnel-through-iap  --ssh-key-file=~/.ssh/google_compute_engine -- -NL 5443:10.103.2.50:443
```
Using bastion from local (for production cluster):
```
gcloud compute ssh --zone "europe-north1-a" "[username]@polis-prod-bastion"  --project "polis-kokeilu-prod" --tunnel-through-iap  --ssh-key-file=~/.ssh/google_compute_engine -- -NL 5443:10.103.2.82:443
```



Set GKE cluster as kubectl context - test:
```
kubectl config use-context gke_polis-kokeilu_europe-north1-c_polis-kokeilu-test-cluster
```
prod:
```
kubectl config use-context gke_polis-kokeilu-prod_europe-north1-c_polis-kokeilu-prod-cluster
```


Apply manifests and use cluster endpoint through SSH tunnel (test):
```
kubectl apply -f manifests/secrets/polis-math-digifinland-secret-gke-test.yaml --server=https://localhost:5443 --insecure-skip-tls-verify=true

kubectl apply -f manifests/secrets/polis-server-digifinland-secret-gke-test.yaml --server=https://localhost:5443 --insecure-skip-tls-verify=true

kubectl apply -f manifests/gke-test/polis-file-server-digifinland.yaml --server=https://localhost:5443 --insecure-skip-tls-verify=true

kubectl apply -f manifests/gke-test/polis-server-digifinland.yaml --server=https://localhost:5443 --insecure-skip-tls-verify=true

kubectl apply -f manifests/gke-test/polis-math-digifinland.yaml --server=https://localhost:5443 --insecure-skip-tls-verify=true
```

Apply manifests and use cluster endpoint through SSH tunnel (prod):
```
kubectl apply -f manifests/secrets/polis-math-digifinland-secret-gke-prod.yaml --server=https://localhost:5443 --insecure-skip-tls-verify=true

kubectl apply -f manifests/secrets/polis-server-digifinland-secret-gke-prod.yaml --server=https://localhost:5443 --insecure-skip-tls-verify=true

kubectl apply -f manifests/gke-prod/polis-file-server-digifinland.yaml --server=https://localhost:5443 --insecure-skip-tls-verify=true

kubectl apply -f manifests/gke-prod/polis-server-digifinland.yaml --server=https://localhost:5443 --insecure-skip-tls-verify=true

kubectl apply -f manifests/gke-prod/polis-math-digifinland.yaml --server=https://localhost:5443 --insecure-skip-tls-verify=true

```

Get shell access to a pod for debugging: 

```
kubectl exec --stdin --server=https://localhost:5443 --insecure-skip-tls-verify=true --tty polis-math-7cd6988885-pz7b9 -- /bin/bash
```

Get env variables from a pod:
```
kubectl exec --server=https://localhost:5443 --insecure-skip-tls-verify=true polis-math-989ff9ddf-77f9f -- env
```

Debug psql connectivity on an Ubuntu based pod's shell (use apk with Alpine)
```
apt-get update
apt-get install postgresql-client-13
psql -h 10.35.0.9 polistestdb -U polistestu
```

# Docker

## Pull images manually (dev tag)
```
docker pull europe-north1-docker.pkg.dev/polis-kokeilu/polis-kokeilu-test/polis-file-server:dev
docker pull europe-north1-docker.pkg.dev/polis-kokeilu/polis-kokeilu-test/polis-math:dev
docker pull europe-north1-docker.pkg.dev/polis-kokeilu/polis-kokeilu-test/polis-server:dev
```


## Publish embed test site (needed this only on local dev env)
```
sudo cp -r ./embed-test-site/ /var/www/html/
sudo cp -rf ./embed-test-site/* /var/www/html/embed-test-site/
```

## Run only the polis-server container
```
DOCKER_ENV=dev docker compose -f docker-compose-digifinland.yml --env-file digifinland-dev.env up server
```

## Scale server to 2 replicas:

Due to docker compose timing issue with replica port allocation we might need to run this twice (as many times as number of replicas):

```
DOCKER_ENV=dev docker compose -f docker-compose-digifinland.yml --env-file digifinland-dev.env up -d --no-deps --scale server=2
```