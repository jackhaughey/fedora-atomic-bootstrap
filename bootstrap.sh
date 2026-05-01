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
mkdir ~/.config/bin
curl -sS https://starship.rs/install.sh | sh -s -- -b ~/.local/bin
starship preset catppuccin-powerline -o ~/.config/starship.toml

# Starship
echo eval "$(starship init bash)" >> ~/.bashrc

# Add mise activation to ~/.bashrc if missing
if ! grep -q 'mise activate bash' "$HOME/.bashrc" 2>/dev/null; then
  echo 'eval "$($HOME/.local/bin/mise activate bash)"' >> "$HOME/.bashrc"
fi

echo "==> Rebooting to apply rpm-ostree changes"
systemctl reboot
