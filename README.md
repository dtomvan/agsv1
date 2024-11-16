# Home-manager module and package for Aylurs-Gtk-Shell V1

This module can be used to use ags v1 alongside ags v2. You can keep both configs side-by-side, so you can keep your old config while iterating on a new one before switching.

## Features
- The ags package will be pinned to the last commit hash for ags v1.
- The binary will install to `agsv1`, so you can still use ags v2 through `ags`.
- The home-manager module will wrap `agsv1`, to use a different config file than `~/.config/ags/config.js`.

## Usage
1. Add this flake as an input to your flake containing your `home-manager` config
   ```nix
   inputs.agsv1.url = "github:dtomvan/agsv1";
   inputs.agsv1.inputs.nixpkgs.follows = "nixpkgs";
   ```
2. Add an overlay to add `agsv1` to your `nixpkgs`
   ```nix
   outputs = { nixpkgs, home-manager, agsv1, ... } : let
     system = "x86_64-linux";
     pkgs = import inputs.nixpkgs {
       inherit system;
       overlays = [(final: prev: {
         agsv1 = agsv1.legacyPackages.${system}.agsv1;
       })];
     };
   in {...}
   ```
3. Add the home-manager module
   ```nix
   homeConfigurations."user" = home-manager.lib.homeManagerConfiguration {
     inherit pkgs;
     modules = [
     agsv1.homeManagerModules.agsv1
     ./home.nix
     ];
   };
   ```
4. In your `home.nix`, configure the module
   ```nix
   programs.agsv1 = {
     enable = true;
     configPath = ./ags-config/config.js;
   };
   ```
5. `home-manager switch`
6. Your config file is now in `~/.config/agsv1` (just the config.js file, but home-manager should've put the rest in the nix store anyways)
7. Run ags (in `exec-once` for example) with `agsv1`. No need to specify `-c` explicitly.
