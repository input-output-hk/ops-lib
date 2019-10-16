#!/usr/bin/env bash

set -euxo pipefail

# Credential setup
if [ ! -f ./static/graylog-creds.nix ]; then
  nix-shell -A gen-graylog-creds
fi

# NixOps setup
export NIXOPS_DEPLOYMENT=example-aws
export NIX_PATH="nixpkgs=$(nix eval '(import ./nix {}).path')"

nixops destroy || true
nixops delete || true
nixops create ./deployments/example-aws.nix -I nixpkgs=./nix
nixops deploy --show-trace
