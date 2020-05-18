{ pkgs }:

self: super:

let
  googleapis_common_protos = super.googleapis_common_protos.overrideAttrs ( oldAttrs: rec {
    pname = "googleapis-common-protos";
    version = "1.6.0";
    src = self.fetchPypi { inherit pname version; };
    propagatedBuildInputs = oldAttrs.propagatedBuildInputs ++ [ self.protobuf ];
    doCheck = false;
    doInstallCheck = false;
  });
in
{
  inherit googleapis_common_protos;
}
