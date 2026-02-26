#!/bin/bash
set -e

echo "Updating Helm dependencies..."
helm dependency update ./Monitoring/helm

helm upgrade --install monitoring ./Monitoring/helm \
  --namespace monitoring \
  --create-namespace

echo "Waiting for Grafana IP..."

while [ -z "$(kubectl get svc monitoring-grafana -n monitoring -o jsonpath='{.status.loadBalancer.ingress[0].ip}')" ]; do
  sleep 10
done

GRAFANA_IP=$(kubectl get svc monitoring-grafana -n monitoring -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
GRAFANA_PASSWORD=$(kubectl get secret -n monitoring monitoring-grafana -o jsonpath="{.data.admin-password}" | base64 --decode)

echo "Grafana URL: http://$GRAFANA_IP"
echo "Username: admin"
echo "Password: $GRAFANA_PASSWORD"