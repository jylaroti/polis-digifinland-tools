# deploy built containers to minikube cluster

# remember to authenticate first to allow minikube to pull images: https://minikube.sigs.k8s.io/docs/handbook/addons/gcp-auth/
# gcloud auth application-default login
# minikube addons enable gcp-auth
# to refresh:
# minikube addons enable gcp-auth --refresh

# to switch between local minikube and gcp, see contexts:
# kubectl config get-contexts
# select local minikube context:
# kubectl config use-context minikube

# deploy to local minikube:
kubectl apply -f manifests/secrets/polis-math-digifinland-secret-local.yaml
kubectl apply -f manifests/secrets/polis-server-digifinland-secret-local.yaml
kubectl apply -f manifests/local-from-registry/polis-file-server-digifinland.yaml
kubectl apply -f manifests/local-from-registry/polis-server-digifinland.yaml
kubectl apply -f manifests/local-from-registry/polis-math-digifinland.yaml

