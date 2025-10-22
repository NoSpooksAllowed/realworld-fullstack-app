#!/bin/bash
set -e

echo "=== Deploy ConfigMaps and Secrets ==="
kubectl apply -f configmaps/
kubectl apply -f secrets/

echo "=== Deploy PostgreSQL ==="
kubectl apply -f base/db/

kubectl wait --for=condition=ready pod -l app=postgres --timeout=120s -n realworld-app

echo "=== Run Migration Job ==="
kubectl apply -f base/backend/job.yaml

kubectl wait --for=condition=complete job/backend-migrate --timeout=120s -n realworld-app

echo "=== Deploy Backend ==="
kubectl apply -f base/backend/deployment.yaml
kubectl apply -f base/backend/service.yaml

kubectl wait --for=condition=ready pod -l app=backend --timeout=120s -n realworld-app

echo "=== Deploy Frontend ==="
kubectl apply -f base/frontend/deployment.yaml
kubectl apply -f base/frontend/service.yaml
kubectl apply -f traefik/ingress.yaml

kubectl wait --for=condition=ready pod -l app=frontend --timeout=120s -n realworld-app

echo "=== Deploy Ingress ==="
kubectl apply -f traefik/ingress.yaml

echo "=== All done! ==="
