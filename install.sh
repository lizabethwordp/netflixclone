#!/bin/bash
kubectl --kubeconfig /custom/path/kube.config --context <CLUSTER_NAME>
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
kubectl port-forward svc/argocd-server -n argocd 8080:443

git clone https://github.com/lizabethwordp/netflixclone.git
cd netflixclone

helm create netflix-app

argocd login <argocd-server-url> --username <username> --password <password>

 argocd app create netflix-app \
	--repo https://github.com/lizabethwordp/netflixclone.git \
	--path netflix-app \
	--dest-server https://kubernetes.default.svc \
	--dest-namespace netflix-app \
	--sync-option CreateNamespace=true \
	--parameter namespace=netflix-app \
application 'netflix-app' created

# Sync the application (deploy)
argocd app sync netflix-app

# Monitor deployment status
argocd app get netflix-app
