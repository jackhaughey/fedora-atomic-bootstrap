# Fedora Atomic Bootstrap

A reproducible bootstrap system for **Fedora Silverblue, Cosmic, Kinoite, and Sericea**.  
This repository automates the installation of essential packages, Flatpaks, and developer tooling on an immutable Fedora Atomic desktop.

It is designed to be paired with a dotfiles manager such as **chezmoi**, and to support containerised development workflows using **Toolbox**, **Distrobox**, and **DevPod**.

---

## Features

- Installs system packages via `rpm-ostree install`
- Installs a curated set of Flatpaks from Flathub
- Provides a clean, repeatable bootstrap workflow for new machines
- Idempotent scripts — safe to re-run
- Minimal, readable structure for easy customisation

---

## Repository Structure
```
fedora-atomic-bootstrap/
├── bootstrap.sh
├── install-flatpaks.sh
├── packages.txt
└── README.md
```

### **[bootstrap.sh](ca://s?q=Explain_bootstrap_sh)**
The main entrypoint. It:

- Reads `packages.txt`
- Installs system packages using `rpm-ostree`
- Triggers a reboot if required
- Calls the Flatpak installer

### **[install-flatpaks.sh](ca://s?q=Explain_install_flatpaks_sh)**
Installs your chosen Flatpaks from Flathub.

### **[packages.txt](ca://s?q=Explain_packages_txt)**
A newline‑separated list of system packages to install.

