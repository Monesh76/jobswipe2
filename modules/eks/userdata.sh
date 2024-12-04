#!/bin/bash
set -o xtrace

# Get the instance ID
INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)

/etc/eks/bootstrap.sh ${cluster_name} \
  --b64-cluster-ca ${cluster_ca} \
  --apiserver-endpoint ${endpoint} \
  --dns-cluster-ip 10.100.0.10 \
  --container-runtime containerd
