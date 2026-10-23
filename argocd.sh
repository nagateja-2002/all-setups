#!/usr/bin/env bash
set -euo pipefail

# Legacy learning script: inspect the downloaded manifest and target cluster
# before running. Use a disposable cluster, not a production kube-context.

# Install Helm (if you plan to use it for other lab steps).
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh
helm version

# Install Argo CD into a dedicated namespace. This is the upstream stable
# manifest, so review it before applying it to your cluster.
kubectl create namespace argocd --dry-run=client -o yaml | kubectl apply -f -
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
kubectl get all -n argocd

# Keep the Argo CD API private for local experimentation. Do not expose the
# admin interface through a public LoadBalancer just for a portfolio demo.
echo "For local access, run in a separate terminal:"
echo "  kubectl port-forward -n argocd svc/argocd-server 8080:443"
echo "Then open https://localhost:8080."

# Retrieve the initial admin password only when needed, locally, and never
# paste it into source control, chat, screenshots, or public issue logs.
echo "To read the initial admin password locally, run:"
echo "  kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d; echo"
