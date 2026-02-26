#!/bin/bash
set -e

cd Infra

echo "Initializing Terraform..."
terraform init -reconfigure \
  -backend-config="resource_group_name=tfstate-rg" \
  -backend-config="storage_account_name=venkat07" \
  -backend-config="container_name=workshop-tfstate" \
  -backend-config="key=workshop-tfstate"

echo "Applying Terraform..."
terraform apply -var-file="test.tfvars" -auto-approve

echo "Reading outputs..."

RG=$(terraform output -raw resource_group_name)
AKS=$(terraform output -raw aks_cluster_name)

echo "Getting AKS credentials..."
az aks get-credentials \
  --resource-group $RG \
  --name $AKS \
  --overwrite-existing

kubectl get nodes