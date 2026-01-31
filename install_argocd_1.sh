# 1. Create the namespace
sudo kubectl create namespace argocd

# 2. Install ArgoCD components
sudo kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# 3. Wait for the pods to be ready (this may take a minute)
sudo kubectl get pods -n argocd -w
