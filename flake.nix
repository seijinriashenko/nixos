{
  description = "My (new) NixOS configuration.";

  inputs = {
    # Nixpks & NixOS-Hardware
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:nixos/nixos-hardware/master";

    # Home-manager
    home-manager = {
      url = "github:nix-community/home-manager/";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Emacs Overlay
    emacs-overlay = {
      url = "github:nix-community/emacs-overlay";
      flake = false;
    };

    # Shameless plug: looking for a way to nixify your themes and make
    # everything match nicely? Try nix-colors!
    # nix-colors.url = "github:misterio77/nix-colors";
  };

  outputs = { self, nixpkgs, home-manager, ... } @ inputs:
  let
    vars = {
      user = "sancti";
      location = "$HOME/.nixos";
      terminal = "alacritty";
      editor = "nvim";
    };
    inherit (self) outputs;
  in {
    nixosConfigurations = (
      import ./hosts {
        inherit (nixpkgs) lib;
	inherit inputs vars;
      }
    );

    homeConfigurations = (
      import ./home {
        inherit (nixpkgs) lib;
	inherit inputs vars;
      }
    );
  };
}
