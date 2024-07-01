# Download the Helm installation script
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3

# Make the script executable
chmod 700 get_helm.sh

# Run the installation script
./get_helm.sh

helm repo add stable https://charts.helm.sh/stable

helm repo update

helm search repo stable

helm install my-release stable/<chart-name>
