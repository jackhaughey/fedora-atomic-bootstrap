#!/usr/bin/env bash
set -e

echo "Enabling Flathub..."
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

echo "Installing Firefox..."
flatpak install -y flathub org.mozilla.firefox

echo "Installing Visual Studio Code..."
flatpak install -y flathub com.visualstudio.code

echo "Installing Shotwell..."
flatpak install -y flathub org.gnome.Shotwell

echo "Installing VLC..."
flatpak install -y flathub org.videolan.VLC

echo "Installing Obsidian..."
flatpak install -y flathub md.obsidian.Obsidian

echo "Installing DevPod..."
mkdir -p ~/.local/bin
curl -L \
  https://github.com/loft-sh/devpod/releases/latest/download/devpod-linux-amd64 \
  -o ~/.local/bin/devpod
chmod +x ~/.local/bin/devpod

echo "All Flatpak applications installed successfully."

echo "Running mise installer..."
sh ./install-mise.sh
