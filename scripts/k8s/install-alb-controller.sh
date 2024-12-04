#!/bin/bash

# Set variables with explicit region configuration
APP_NAME="jobswipe"
ENVIRONMENT="dev"
CLUSTER_NAME="${APP_NAME}-${ENVIRONMENT}"
AWS_REGION="us-west-1"

# First, ensure we're using the correct region
aws configure set region us-west-1

echo "Cleaning up any previous installation..."
helm uninstall aws-load-balancer-controller -n kube-system 2>/dev/null || true

echo "Verifying cluster access in us-west-1..."
if ! aws eks describe-cluster --name $CLUSTER_NAME --region $AWS_REGION > /dev/null 2>&1; then
    echo "Error: Cannot access cluster '$CLUSTER_NAME' in us-west-1. Please check:"
    echo "  1. The cluster name is correct"
    echo "  2. Your AWS credentials are properly configured"
    echo "  3. The cluster exists in us-west-1 region"
    echo ""
    echo "Current AWS configuration:"
    aws configure list
    exit 1
fi

echo "Adding EKS Helm repository..."
helm repo add eks https://aws.github.io/eks-charts
helm repo update

echo "Getting VPC ID from cluster..."
VPC_ID=$(aws eks describe-cluster \
    --name $CLUSTER_NAME \
    --region $AWS_REGION \
    --query "cluster.resourcesVpcConfig.vpcId" \
    --output text)

AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)

echo "Installing AWS Load Balancer Controller..."
helm install aws-load-balancer-controller eks/aws-load-balancer-controller \
  -n kube-system \
  --set clusterName=$CLUSTER_NAME \
  --set serviceAccount.create=true \
  --set serviceAccount.name=aws-load-balancer-controller \
  --set serviceAccount.annotations."eks\.amazonaws\.com/role-arn"=arn:aws:iam::${AWS_ACCOUNT_ID}:role/aws-load-balancer-controller \
  --set region=$AWS_REGION \
  --set vpcId=$VPC_ID \
  --wait

echo "Verifying installation..."
kubectl get deployment -n kube-system aws-load-balancer-controller

echo "Checking controller pods..."
kubectl get pods -n kube-system -l app.kubernetes.io/name=aws-load-balancer-controller

# Update kubeconfig just in case it's needed
echo "Updating kubeconfig for us-west-1..."
aws eks update-kubeconfig --name $CLUSTER_NAME --region $AWS_REGION

echo "Installation complete. Please check the pod status above."