#!/usr/bin/env bash
set -euo pipefail

echo "Removing default Firefox RPM..."
sudo rpm-ostree override remove firefox firefox-langpacks

echo "==> Applying rpm-ostree package layering"
sudo rpm-ostree install \
    git \
    tmux \
    htop \
    alacritty \
    chezmoi \
    distrobox

echo "==> Installing Starship prompt"
STARSHIP_VERSION="1.18.2"
STARSHIP_URL="https://github.com/starship/starship/releases/download/v${STARSHIP_VERSION}/starship-x86_64-unknown-linux-gnu.tar.gz"

mkdir -p /tmp/starship-install
curl -fsSL "${STARSHIP_URL}" -o /tmp/starship-install/starship.tar.gz
tar -xzf /tmp/starship-install/starship.tar.gz -C /tmp/starship-install

install -Dm755 /tmp/starship-install/starship /usr/local/bin/starship

echo "==> Cleaning up Starship temp files"
rm -rf /tmp/starship-install

echo "==> Rebooting to apply rpm-ostree changes"
systemctl reboot
