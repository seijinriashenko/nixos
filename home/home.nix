{ inputs, pkgs, vars, ... } : {
  home = {
    packages = [
    ];

    activation = {
      linkDesktopApplications = {
	# Add Packages To System Menu by updating database
        after = [ "writeBoundary" "createXdgUserDirectories" ];
	before = [ ];
	data = "sudo /usr/bin/update-desktop-database";
      };
    };
  };

  xdg = {
    enable = true;
    # Add Nix Packages to XDG_DATA_DIRS
    systemDirs.data = [ "/home/${vars.user}/.nix-profile/share" ];
  };

  nix = {
    settings = {
      auto-optimise-store = true;
    };
    package = pkgs.nixFlakes;
    registry.nixpkgs.flake = inputs.nixpkgs;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };
  nixpkgs.config.allowUnfree = true;
}
