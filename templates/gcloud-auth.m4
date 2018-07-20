#!/bin/bash

#
# This is a rather minimal example Argbash potential
# Example taken from http://argbash.readthedocs.io/en/stable/example.html
#
# ARG_OPTIONAL_SINGLE([gcloud_key], [k], [Google Cloud key in base64], [])
# ARG_OPTIONAL_SINGLE([gcloud_key_env], [e], [Env name with google cloud key], [GCLOUD_KEY])
# ARG_OPTIONAL_SINGLE([zone], [z], [Google cloud zone], [])
# ARG_OPTIONAL_SINGLE([region], [r], [Google Cloud region], [])
# ARG_OPTIONAL_SINGLE([k8s_cluster], [c], [Kubernets cluster name], [])
# ARG_HELP([Athentication in google cloud service])
# ARGBASH_GO

# [ <-- needed because of Argbash

# Not save history
export HISTIGNORE=' *'

# Default by envs
_default_key=$(printf '%s\n' "${!_arg_gcloud_key_env}")
_arg_gcloud_key=${_arg_gcloud_key:-$_default_key}
_arg_zone=${_arg_zone:-$GCLOUD_ZONE}
_arg_region=${_arg_region:-$GCLOUD_REGION}
_arg_k8s_cluster=${_arg_k8s_cluster:-$GCLOUD_K8S_CLUSTER}

if [ -z $_arg_gcloud_key ]; then
  echo "Require --gcloud_key option or \$GCLOUD_KEY env"
  exit 1
fi

# Connect gcloud
_json_key_file="/tmp/gcloud_key.json"
echo $_arg_gcloud_key | base64 -d > $_json_key_file
gcloud auth activate-service-account --key-file $_json_key_file

gcloud config set project $(cat $_json_key_file | jq ".project_id" -r)

[ -n "$_arg_zone" ] && gcloud config set compute/zone $_arg_zone
[ -n "$_arg_region" ] && gcloud config set compute/region $_arg_region

if [ -n "$_arg_k8s_cluster" ]; then
  gcloud container clusters get-credentials $_arg_k8s_cluster
  kubectl get pods
fi

# ] <-- needed because of Argbash
