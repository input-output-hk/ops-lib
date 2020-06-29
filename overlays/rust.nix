self: super:
let
  rustChannel = self.rustChannelOf { date = "2020-02-04"; channel = "nightly"; };
in
rec {
  rustc = rustChannel.rust;
  cargo = rustChannel.cargo;
  rustPlatform = super.recurseIntoAttrs (super.rust.makeRustPlatform {
    rustc = rustChannel.rust;
    cargo = rustChannel.cargo;
  });
}
