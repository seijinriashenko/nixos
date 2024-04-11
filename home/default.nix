{ inputs, lib, config, pkgs, vars, ... }:
let
  nixpkgs = inputs.nixpkgs;
  home-manager = inputs.home-manager;

  system = "x86_64-linux";
  pkgs = nixpkgs.legacyPackages.${system};
in {
  home = home-manager.lib.homeManagerConfiguration {
    inherit pkgs;
    extraSpecialArgs = { inherit inputs vars; };
    modules = [
      ./home.nix
      {
        home = {
	  username = "${vars.user}";
	  homeDirectory = "/home/${vars.user}";
	  packages = [ pkgs.home-manager ];
	  stateVersion = "23.11";
	};
      }
    ];
  };
}
