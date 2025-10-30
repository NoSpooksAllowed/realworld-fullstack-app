#!/bin/bash
echo "=== Deploy PostgreSQL ==="
kubectl apply -f db/

kubectl wait --for=condition=ready pod -l app=postgres --timeout=120s -n realworld-app
