#!/usr/bin/env bash

set -euxo pipefail

# https://nixos.org/nixops/manual/#idm140737322394336
# Needed for libvirtd:
#
# virtualisation.libvirtd.enable = true;
# networking.firewall.checkReversePath = false;

if [ ! -d /var/lib/libvirt/images ]; then
  sudo mkdir -p /var/lib/libvirt/images
  sudo chgrp libvirtd /var/lib/libvirt/images
  sudo chmod g+w /var/lib/libvirt/images
fi

# NixOps setup

export NIXOPS_DEPLOYMENT=jormungandr-performance-libvirtd

nixops destroy || true
nixops delete || true
nixops create ./deployments/jormungandr-performance-libvirtd.nix -I nixpkgs=./nix
nixops set-args --arg globals 'import ./globals.nix'
nixops deploy
