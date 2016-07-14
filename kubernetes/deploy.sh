#!/bin/sh

# Assumes standard config pattern (TODO doc)
# Assumes running in deployment root
# Requires PROJECT_NAME, CIRCLE_SHA1, APP_NAME env variables to be set.

set -e

export NAMESPACE=$1

if [ -z "${NAMESPACE}" ]; then
  echo "NAMESPACE not specified"
  exit 1
fi
if [ -z "${CLUSTER_NAME}" ]; then
  echo "CLUSTER_NAME not set"
  exit 1
fi
if [ -z "${PROJECT_NAME}" ]; then
  echo "PROJECT_NAME not set"
  exit 1
fi
if [ -z "${CIRCLE_SHA1}" ]; then
  echo "CIRCLE_SHA1 not set"
  exit 1
fi
if [ -z "${APP_NAME}" ]; then
  echo "APP_NAME not set"
  exit 1
fi

# Get creds and set kubectl context for target cluster
sudo /opt/google-cloud-sdk/bin/gcloud --quiet container clusters get-credentials $CLUSTER_NAME

# Substitute env vars in yaml.tmpl files
envsubst < deployment.yaml.tmpl > k8-deployment.yaml
envsubst < service.yaml.tmpl > k8-service.yaml

# Push out the image
sudo /opt/google-cloud-sdk/bin/gcloud docker push gcr.io/${PROJECT_NAME}/${APP_NAME}:${CIRCLE_SHA1}

echo "Updating service..."
kubectl apply -f ./k8-service.yaml

echo "Updating deployment..."
cat ./k8-deployment.yaml
kubectl apply -f ./k8-deployment.yaml
