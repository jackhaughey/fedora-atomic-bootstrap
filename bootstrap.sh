#!/usr/bin/env bash
set -e

echo "Installing layered packages..."
sudo rpm-ostree install $(cat packages.txt)

echo "Rebooting to apply layers..."
systemctl reboot
