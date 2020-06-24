{ pkgs ? import ../nix { }, staticPath }:
pkgs.mkShell {
  name = "gen-sentry-secret-key";
  buildInputs = with pkgs; [ sentry ];
  shellHook = ''
    keyFilename="sentry-secret-key.nix"    # Default sentry secret-key filename
    staticPath=${toString staticPath}     # Absolute path to the static dir

    if [[ -e "$staticPath/$keyFilename" ]]; then
      echo "File already exists: $staticPath/$keyFilename, aborting!"
      exit 1
    fi
    echo "Writing sentry secret-key..."

    umask 077
    cd $path
    sentry config generate-secret-key > $staticPath/$keyFilename
    exit 0
  '';
}
