{
  description = "A flake that exposes ags version 1 under the binary `agsv1`";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    ags.url = "github:Aylur/ags/67b0e31ded361934d78bddcfc01f8c3fcf781aad";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    ags,
  }: let
    systems = ["x86_64-linux" "aarch64-linux"];
  in
    flake-utils.lib.simpleFlake {
      inherit self nixpkgs systems;
      name = "agsv1";
      overlay = ./overlay.nix;
      preOverlays = [
        (final: prev: {
          ags = ags.packages."${prev.system}".ags;
        })
      ];
    } // {
      homeManagerModules.agsv1 = import ./hm.nix self;
    };
}
