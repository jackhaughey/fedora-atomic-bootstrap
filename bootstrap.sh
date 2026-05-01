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
curl -sS https://starship.rs/install.sh | sh -s -- -b ~/.local/bin
starship preset catppuccin-powerline -o ~/.config/starship.toml

echo "==> Rebooting to apply rpm-ostree changes"
systemctl reboot
