# Polis DigiFinland Tools

Set of deploy scripts, settings files, custom patches, translations and utilities for running Polis experiment deployments for DigiFinland.

## Initialization

1. Create a suitable working directory.

2. Clone Polis repository into working dir. Also fix line endings with autocrlf.

    ```
    git config --global core.autocrlf true
    git clone https://github.com/compdemocracy/polis.git
    ```

3. Clone this repository into working dir.

    ```
    git clone git@github.com:polis-digifinland-tools/polis-digifinland-tools.git
    ```


4. Working dir should now contain directories ./polis (polis official codebase) and ./polis-digifinland-tools (customizations and configurations for DigiFinland)

5. Add polis.local entry to your hosts file:
    ```
    127.0.0.1 	polis.local
    ```

## Initialize database

Uncomment postgres service in docker-compose-digifinland.yml before first run if you don't have existing database to work with. This runs default database initialization & migration SQL scripts from the project.

To simulate GKE + Cloud SQL (GCE VM) based deployment, install Postgres V13 on your host and use suitable test DB dump. See documentation about Test VM setup and Postgres configuration on Confluence workspace.

## Patch codebase

To patch polis with DigiFinland customizations and settings run patch script.

This fetches latest Polis version from origin/edge branch and adds configs and patches. 

```
cd ./polis-digifinland-tools/
./scripts/patch-polis-codebase.sh
```

# Docker

## Setup nginx as local loadbalancer

To simulate GKE + Cloud SQL (GCE VM) based deployment, install nginx on your host and setup proxy with example site configurations provided in the `nginx` directory. See documentation about Test VM setup and Nginx configuration on Confluence workspace. 

You can also use nginx container in a way it is used in the original codebase.

## Run dev env with Docker Compose

After patching, build and start all containers.
Script takes env identifier (dev or test) as argument. 

```
./scripts/docker-compose_build-and-deploy.sh dev
```

## Scale polis-server
```
cd ./polis/
DOCKER_ENV=dev docker compose -f docker-compose-digifinland.yml --env-file digifinland-dev.env up -d --no-deps --scale server=2
```

## Stop and remove containers

Takes env identifier (dev or test) as argument. 
```
./scripts/docker-compose_stop.sh dev
```

# Minikube & Skaffold

Kubernetes configuration files are in ./manifests directory.
See skaffold.yaml for artifacts and build config.

Starts containers in local Minikube cluster, builds and deploys containers using Skaffold:
```
./scripts/k8s_start-local-minikube-and-run-skaffold.sh
```

Starts local Minikube cluster:
```
./scripts/k8s_start-local-minikube-and-run-skaffold.sh
```

Deploys prebuilt images from registry to local Minikube cluster with kubectl:
```
./scripts/k8s_deploy-local.sh
```

# Test Server and GKE clusters

For detailed documentation about setting up Test Server on GCE virtual machine manually, and setting up test and production GKE clusters, see documentation in Confluence workspace.

Build images and push to test project's artifact repository:
```
./scripts/docker_images-build-and-push.sh test
```

Build images and push to production project's artifact repository:
```
./scripts/docker_images-build-and-push-prod.sh prod
```



# Tips and Troubleshooting

See [Tips and troubleshooting](docs/tips-and-troubleshooting.md).