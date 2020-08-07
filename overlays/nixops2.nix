self: super: {
  nixops2 = let
    nixpkgsNixops2 = self.sourcePaths.nixpkgs-nixops2;
    patches = [
      ./patches/nixpkgs-pr83548.patch
    ];
    nixpkgsNixops2PatchedSrc = self.runCommand "nixpkgs-${self.sourcePaths.nixpkgs-nixops2.rev}-patched" {
        inherit nixpkgsNixops2;
        inherit patches;
      } ''
      cp -r $nixpkgsNixops2 $out
      chmod -R +w $out
      for p in $patches; do
        echo "Applying patch $p";
        patch -d $out -p1 < "$p";
      done
    '';
    nixpkgsNixops2Patched = import nixpkgsNixops2PatchedSrc {};

  in nixpkgsNixops2Patched.nixops2Unstable.withPlugins (ps: with ps; [
    nixops-aws
    nixops-virtd
    nixops-encrypted-links
    nixops-gcp
    nixopsvbox
  ]);

  nixops2Wrapped = self.runCommand "nixops2" {
      buildInputs = [ self.makeWrapper ];
    } ''
    mkdir $out
    ln -s ${self.nixops2}/* $out
    rm $out/bin
    mkdir $out/bin
    ln -s ${self.nixops2}/bin/* $out/bin
    rm $out/bin/nixops
    makeWrapper ${self.nixops2}/bin/nixops $out/bin/nixops2
  '';
}
