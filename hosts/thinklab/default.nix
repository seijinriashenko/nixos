{ inputs, lib, config, pkgs, ... }: {
  ### IMPORTS ###
  imports = [
    inputs.nixos-hardware.nixosModules.lenovo-thinkpad-x220

    ./hardware-configuration.nix
  ];
    
  ### BOOTLOADER ###
  boot = {
    loader = {
      systemd-boot = {
        enable = true;
	configurationLimit = 3;
      };
      efi = {
        canTouchEfiVariables = true;
      };
      timeout = 5;
    };
  };

  river.enable = true;

  ### HARDWARE ###
  hardware = {
    opengl = {
      enable = true;
      extraPackages = with pkgs; [
        intel-media-driver
	vaapiIntel
	vaapiVdpau
	libvdpau-va-gl
      ];
    };
  };

  ### ENVIRONMENT ###
  environment = {
    systemPackages = with pkgs; [
    ];
  };

  ### PROGRAMS ###
  programs = {
    light.enable = true;
  };
}

