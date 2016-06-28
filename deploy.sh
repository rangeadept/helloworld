#!/bin/bash

# Exit on any error
set -e

sudo /opt/google-cloud-sdk/bin/gcloud docker push gcr.io/${PROJECT_NAME}/${APP_NAME}
# sudo chown -R ubuntu:ubuntu /home/ubuntu/.kube

kubectl --namespace default apply -f ./k8-service.yaml
kubectl --namespace default apply -f ./k8-deployment.yaml
