#!/usr/bin/env bash
set -euo pipefail

echo "[*] Updating base system..."
sudo dnf -y upgrade

echo "[*] Installing base tooling..."
sudo dnf install -y \
  git curl wget unzip tar gnupg \
  jq yq \
  fzf ripgrep bat tmux \
  httpie \
  bind-utils traceroute nmap \
  podman buildah skopeo \
  python3-pip \
  openssl

########################################
# Terraform + Terragrunt + linters
########################################
echo "[*] Installing Terraform..."
#sudo dnf install -y dnf-plugins-core
#sudo dnf config-manager --add-repo https://rpm.releases.hashicorp.com/fedora/hashicorp.repo
#sudo dnf install -y terraform packer

TF_VERSION=$(curl -s https://api.github.com/repos/hashicorp/terraform/releases/latest \
  | grep tag_name | cut -d '"' -f 4 | sed 's/v//')

curl -LO https://releases.hashicorp.com/terraform/${TF_VERSION}/terraform_${TF_VERSION}_linux_amd64.zip
unzip -o terraform_${TF_VERSION}_linux_amd64.zip
sudo mv terraform /usr/local/bin/
rm terraform_${TF_VERSION}_linux_amd64.zip

echo "[✓] Terraform installed."

echo "[*] Installing Packer..."

PK_VERSION=$(curl -s https://api.github.com/repos/hashicorp/packer/releases/latest \
  | grep tag_name | cut -d '"' -f 4 | sed 's/v//')

curl -LO https://releases.hashicorp.com/packer/${PK_VERSION}/packer_${PK_VERSION}_linux_amd64.zip
unzip -o packer_${PK_VERSION}_linux_amd64.zip
sudo mv packer /usr/local/bin/
rm packer_${PK_VERSION}_linux_amd64.zip

echo "[✓] Packer installed."

echo "[*] Installing Terragrunt..."
TG_VERSION="v0.67.6"
curl -L "https://github.com/gruntwork-io/terragrunt/releases/download/${TG_VERSION}/terragrunt_linux_amd64" -o terragrunt
chmod +x terragrunt
sudo mv terragrunt /usr/local/bin/terragrunt

echo "[*] Installing tflint..."
TFLINT_VERSION="v0.53.0"
curl -L "https://github.com/terraform-linters/tflint/releases/download/${TFLINT_VERSION}/tflint_linux_amd64.zip" -o tflint.zip
unzip -o tflint.zip
rm tflint.zip
chmod +x tflint
sudo mv tflint /usr/local/bin/tflint

echo "[*] Installing tfsec..."
TFSEC_VERSION="v1.28.10"
curl -L "https://github.com/aquasecurity/tfsec/releases/download/${TFSEC_VERSION}/tfsec-linux-amd64" -o tfsec
chmod +x tfsec
sudo mv tfsec /usr/local/bin/tfsec

echo "[*] Installing Checkov..."
pip install --user checkov

########################################
# Cloud CLIs: AWS, Azure, kubectl
########################################
echo "[*] Installing AWS CLI v2..."
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o awscliv2.zip
unzip -o awscliv2.zip
sudo ./aws/install
rm -rf aws awscliv2.zip

echo "[*] Installing AWS SSM Session Manager plugin..."
curl "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/linux_64bit/session-manager-plugin.rpm" -o session-manager-plugin.rpm
sudo dnf install -y ./session-manager-plugin.rpm
rm session-manager-plugin.rpm

echo "[*] Installing Azure CLI..."
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
sudo dnf install -y https://packages.microsoft.com/config/fedora/40/packages-microsoft-prod.rpm
sudo dnf install -y azure-cli

echo "[*] Installing Azure Bicep..."
az bicep install || true

echo "[*] Installing kubectl..."
sudo dnf install -y kubernetes-client

# Optional: gcloud
# echo "[*] Installing Google Cloud SDK..."
# sudo tee /etc/yum.repos.d/google-cloud-sdk.repo >/dev/null << 'EOF'
# [google-cloud-sdk]
# name=Google Cloud SDK
# baseurl=https://packages.cloud.google.com/yum/repos/cloud-sdk-el8-x86_64
# enabled=1
# gpgcheck=1
# repo_gpgcheck=1
# gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg
#        https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
# EOF
# sudo dnf install -y google-cloud-sdk

########################################
# Kubernetes ecosystem
########################################
echo "[*] Installing Helm..."
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

echo "[*] Installing k9s..."
K9S_VERSION="v0.32.5"
curl -L "https://github.com/derailed/k9s/releases/download/${K9S_VERSION}/k9s_Linux_amd64.tar.gz" -o k9s.tar.gz
tar -xzf k9s.tar.gz k9s
rm k9s.tar.gz
chmod +x k9s
sudo mv k9s /usr/local/bin/k9s

echo "[*] Installing kubectx + kubens..."
git clone https://github.com/ahmetb/kubectx.git /tmp/kubectx
sudo mv /tmp/kubectx/kubectx /usr/local/bin/kubectx
sudo mv /tmp/kubectx/kubens /usr/local/bin/kubens
rm -rf /tmp/kubectx

echo "[*] Installing stern..."
STERN_VERSION="v1.30.0"
curl -L "https://github.com/stern/stern/releases/download/${STERN_VERSION}/stern_${STERN_VERSION#v}_linux_amd64.tar.gz" -o stern.tar.gz
tar -xzf stern.tar.gz stern
rm stern.tar.gz
chmod +x stern
sudo mv stern /usr/local/bin/stern

echo "[*] Installing kustomize..."
KUSTOMIZE_VERSION="v5.5.0"
curl -L "https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2F${KUSTOMIZE_VERSION}/kustomize_${KUSTOMIZE_VERSION}_linux_amd64.tar.gz" -o kustomize.tar.gz
tar -xzf kustomize.tar.gz kustomize
rm kustomize.tar.gz
chmod +x kustomize
sudo mv kustomize /usr/local/bin/kustomize

echo "[*] Installing Flux CLI..."
curl -s https://fluxcd.io/install.sh | sudo bash

echo "[*] Installing Helmfile..."
HELMFILE_VERSION="v0.165.0"
curl -L "https://github.com/helmfile/helmfile/releases/download/${HELMFILE_VERSION}/helmfile_${HELMFILE_VERSION#v}_linux_amd64.tar.gz" -o helmfile.tar.gz
tar -xzf helmfile.tar.gz helmfile
rm helmfile.tar.gz
chmod +x helmfile
sudo mv helmfile /usr/local/bin/helmfile

########################################
# Argo CD CLI
########################################
echo "[*] Installing Argo CD CLI..."

ARGOCD_VERSION=$(curl -s https://api.github.com/repos/argoproj/argo-cd/releases/latest \
  | grep tag_name | cut -d '"' -f 4)

curl -sSL -o argocd \
  "https://github.com/argoproj/argo-cd/releases/download/${ARGOCD_VERSION}/argocd-linux-amd64"

chmod +x argocd
sudo mv argocd /usr/local/bin/argocd

echo "[✓] Argo CD CLI installed."


########################################
# Observability / testing
########################################
echo "[*] Installing k6..."
K6_VERSION="v0.54.0"
curl -L "https://github.com/grafana/k6/releases/download/${K6_VERSION}/k6-v0.54.0-linux-amd64.tar.gz" -o k6.tar.gz
tar -xzf k6.tar.gz
sudo mv k6-v0.54.0-linux-amd64/k6 /usr/local/bin/k6
rm -rf k6.tar.gz k6-v0.54.0-linux-amd64

echo "[*] Installing hey..."
HEY_VERSION="v0.1.4"
curl -L "https://github.com/rakyll/hey/releases/download/${HEY_VERSION}/hey_linux_amd64" -o hey
chmod +x hey
sudo mv hey /usr/local/bin/hey

echo "[*] Installing grpcurl..."
GRPCURL_VERSION="v1.9.1"
curl -L "https://github.com/fullstorydev/grpcurl/releases/download/${GRPCURL_VERSION}/grpcurl_${GRPCURL_VERSION#v}_linux_x86_64.tar.gz" -o grpcurl.tar.gz
tar -xzf grpcurl.tar.gz grpcurl
rm grpcurl.tar.gz
chmod +x grpcurl
sudo mv grpcurl /usr/local/bin/grpcurl

########################################
# Ansible
########################################
echo "[*] Installing Ansible..."
sudo dnf install -y ansible

########################################
# GitHub CLI
########################################
echo "[*] Installing GitHub CLI..."
sudo dnf install -y gh

echo
echo "[✓] Full cloud engineering toolchain installed."
echo "You may want to add ~/.local/bin to PATH for pip tools (e.g. checkov)."
