#! /bin/bash
echo $GCLOUD_KEY | base64 -d > gcloud.p12

gcloud auth activate-service-account $GCLOUD_EMAIL --key-file gcloud.p12
gcloud config set compute/region $GCLOUD_REGION
gcloud config set compute/zone $GCLOUD_ZONE
gcloud container clusters get-credentials $GCLOUD_CLUSTER
kubectl get nodes

ssh-keygen -f ~/.ssh/google_compute_engine -N ""
