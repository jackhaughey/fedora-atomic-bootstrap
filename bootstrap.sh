#!/usr/bin/env bash
set -e

echo "Removing default Firefox RPM..."
sudo rpm-ostree override remove firefox

echo "Installing layered packages..."
sudo rpm-ostree install \
  git \
  openssh-clients \
  tmux \
  htop \
  alacritty \
  chezmoi \
  distrobox

echo "Rebooting to apply layered changes..."
systemctl reboot
