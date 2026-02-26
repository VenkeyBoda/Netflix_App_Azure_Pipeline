#!/bin/bash
set -e

echo "========================================="
echo " Updating Helm Dependencies"
echo "========================================="

helm dependency update ./Monitoring/helm

echo "========================================="
echo " Deploying Monitoring Stack"
echo "========================================="

helm upgrade --install monitoring ./Monitoring/helm \
  --namespace monitoring \
  --create-namespace

echo "========================================="
echo " Waiting for Grafana LoadBalancer"
echo "========================================="

ATTEMPTS=30
SLEEP_SECONDS=10

for ((i=1;i<=ATTEMPTS;i++)); do

  GRAFANA_IP=$(kubectl get svc monitoring-grafana -n monitoring -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
  GRAFANA_HOSTNAME=$(kubectl get svc monitoring-grafana -n monitoring -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')

  if [ -n "$GRAFANA_IP" ]; then
      echo "Grafana IP assigned!"
      GRAFANA_URL=$GRAFANA_IP
      break
  fi

  if [ -n "$GRAFANA_HOSTNAME" ]; then
      echo "Grafana Hostname assigned!"
      GRAFANA_URL=$GRAFANA_HOSTNAME
      break
  fi

  echo "Waiting... attempt $i/$ATTEMPTS"
  sleep $SLEEP_SECONDS
done

if [ -z "$GRAFANA_URL" ]; then
  echo "ERROR: Grafana LoadBalancer not ready."
  exit 1
fi

echo "========================================="
echo " Fetching Grafana Credentials"
echo "========================================="

GRAFANA_PASSWORD=$(kubectl get secret -n monitoring monitoring-grafana \
  -o jsonpath="{.data.admin-password}" | base64 --decode)

echo ""
echo "========================================="
echo " Grafana Access Details"
echo "========================================="
echo "URL: http://$GRAFANA_URL"
echo "Username: admin"
echo "Password: $GRAFANA_PASSWORD"
echo "========================================="