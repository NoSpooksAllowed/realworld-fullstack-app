#!/bin/bash
set -e

echo "=== Deploy ConfigMaps and Secrets ==="
kubectl apply -f configmaps/
kubectl apply -f secrets/backend-secrets.yaml

echo "=== Run Migration Job ==="
kubectl delete job backend-migrate -n realworld-app --ignore-not-found=true
kubectl apply -f base/backend/job.yaml

kubectl wait --for=condition=complete job/backend-migrate --timeout=120s -n realworld-app

echo "=== Deploy Backend ==="
kubectl apply -f base/backend/deployment.yaml
kubectl apply -f base/backend/service.yaml

kubectl rollout status deployment/backend-dep -n realworld-app --timeout=120s

echo "=== Deploy Frontend ==="
kubectl apply -f base/frontend/deployment.yaml
kubectl apply -f base/frontend/service.yaml

kubectl rollout status deployment/frontend-dep -n realworld-app --timeout=120s

echo "=== Deploy Ingress ==="
kubectl apply -f traefik/ingress.yaml

echo "=== All done! ==="
