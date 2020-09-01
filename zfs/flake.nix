{
  description = "zfs image for amazon";
  inputs = {
  };
  outputs = { self, nixpkgs, ... }:
  {
    nixosModules = {
      make-zfs-image = ./make-zfs-image.nix;
      zfs-runtime = ./zfs-runtime.nix;
    };
    lib = {
      uploadAmiImage = import ./upload-ami.nix { pkgs = import nixpkgs {}; };
    };
  };
}
