#!/usr/bin/env bash
# Download Expressvpn
wget https://www.expressvpn.works/clients/linux/expressvpn-linux-universal-14.1.1.13156_release.run
chmod +x expressvpn-linux-universal-14.1.1.13156_release.run
sudo dnf install procps-ng psmisc libatomic brotli
./expressvpn-linux-universal-14.1.1.13156_release.run

# Remember to get a token to make an activation file
## Activate uising expressvpnctl activate FILENAME
