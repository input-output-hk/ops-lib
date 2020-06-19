{ buildPythonPackage
, fetchFromGitHub
, milksnake
, naersk
, pkg-config
, openssl
}:

let
  rust-symbolic = import ./rust.nix { inherit naersk fetchFromGitHub pkg-config openssl; };
in

import ./python.nix { inherit buildPythonPackage fetchFromGitHub rust-symbolic milksnake; }
