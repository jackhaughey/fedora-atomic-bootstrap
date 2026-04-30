#!/usr/bin/env bash
set -e

echo "Installing mise (official upstream)..."

# Install mise into ~/.local/share/mise and ~/.local/bin/mise
curl https://mise.jdx.dev/install.sh | sh

echo "Adding mise shell activation to ~/.bashrc and ~/.zshrc..."

# Bash
if ! grep -q 'mise activate bash' ~/.bashrc 2>/dev/null; then
  echo 'eval "$($HOME/.local/bin/mise activate bash)"' >> ~/.bashrc
fi

# Zsh
if ! grep -q 'mise activate zsh' ~/.zshrc 2>/dev/null; then
  echo 'eval "$($HOME/.local/bin/mise activate zsh)"' >> ~/.zshrc
fi

echo "mise installation complete."
