#!/bin/bash
kubectl --kubeconfig /custom/path/kube.config --context <CLUSTER_NAME>
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
kubectl port-forward svc/argocd-server -n argocd 8080:443

# Log in to ArgoCD (if not already logged in)
argocd login <argocd-server-url> --username <username> --password <password>

# Create an application
argocd app create my-app \
    --repo <git-repo-url> \
    --path <path-to-app-yaml> \
    --dest server:default

# Sync the application (deploy)
argocd app sync my-app

# Monitor deployment status
argocd app get my-app
