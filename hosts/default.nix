{ inputs, vars, ... }:
let
  system = "x86_64-linux";

  pkgs = import inputs.nixpkgs {
    inherit system;
    config.allowUnfree = true;
  };

  lib = inputs.nixpkgs.lib;
  home-manager = inputs.home-manager;
in {
  thinklab = lib.nixosSystem {
    inherit system;
    specialArgs = {
      inherit inputs vars system;
      host = {
        hostName = "thinklab";
      };
    };
    modules = [
      ./thinklab
      ./configuration.nix

      home-manager.nixosModules.home-manager {
        home-manager.useGlobalPkgs = true;
	home-manager.useUserPackages = true;
      }
    ];
  };
}

