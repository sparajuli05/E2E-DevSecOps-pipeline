#!/bin/bash

# 1. Create the namespace
echo "Creating argocd namespace..."
sudo kubectl create namespace argocd || echo "Namespace already exists"

# 2. Apply ArgoCD Manifests
echo "Applying ArgoCD manifests..."
sudo kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# 3. Wait for ArgoCD Server to be ready
echo "Waiting for ArgoCD server pod to be ready (this may take 1-2 minutes)..."
sudo kubectl wait --for=condition=available --timeout=300s deployment/argocd-server -n argocd

# 4. Patch Service to NodePort
echo "Exposing ArgoCD via NodePort..."
sudo kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "NodePort"}}'

# 5. Extract Credentials and Access Info
ARGOCD_PORT=$(sudo kubectl get svc argocd-server -n argocd -o jsonpath='{.spec.ports[?(@.port==443)].nodePort}')
ADMIN_PASSWORD=$(sudo kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)
EC2_PUBLIC_IP=$(curl -s http://checkip.amazonaws.com)

echo "---------------------------------------------------"
echo "✅ ArgoCD Setup Complete!"
echo "---------------------------------------------------"
echo "URL: https://${EC2_PUBLIC_IP}:${ARGOCD_PORT}"
echo "Username: admin"
echo "Password: ${ADMIN_PASSWORD}"
echo "---------------------------------------------------"
echo "⚠️ IMPORTANT: Ensure Port ${ARGOCD_PORT} is open in your AWS Security Group!"
