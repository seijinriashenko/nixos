# General system configuration

{ inputs, lib, config, pkgs, vars, host, ... }:
let
  terminal = pkgs.${vars.terminal};
in {
  ### IMPORTS ###
  imports = (import ../modules/desktops ++
    import ../modules/editors ++
    import ../modules/programs ++
    import ../modules/services ++
    import ../modules/shell ++
    import ../modules/theming);

  ### BOOTLOADER ###
  boot = {
    tmp = {
      cleanOnBoot = true;
      tmpfsSize = "5GB";
    };
  };

  ### SYSTEM TIME ###
  time.timeZone = "Europe/Kyiv";

  ### LOCALE ###
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      #LC_ADDRESS = "uk_UA.UTF-8";
      #LC_IDENTIFICATION = "uk_UA.UTF-8";
      LC_MEASUREMENT = "uk_UA.UTF-8";
      LC_MONETARY = "uk_UA.UTF-8";
      #LC_NAME = "uk_UA.UTF-8";
      #LC_NUMERIC = "uk_UA.UTF-8";
      #LC_PAPER = "uk_UA.UTF-8";
      #LC_TELEPHONE = "uk_UA.UTF-8";
      #LC_TIME = "uk_UA.UTF-8";
    };
  };

  ### NETWORK ###
  networking = with host; {
    hostName = hostName;
    networkmanager.enable = true;

    #firewall = {
    #  enable = false;
    #  allowedTCPPorts = [ ... ];
    #  allowedUDPPorts = [ ... ];
    #};

    #proxy = {
    #  default = "http://user:password@proxy:port/";
    #  noProxy = "127.0.0.1,localhost,internal.domain";
    #};
  };

  ### SECURITY ###
  security = {
    rtkit.enable = true;
    polkit.enable = true;
  };

  ### USERS and GROUPS ###
  users = {
    users = {
      ${vars.user} = {
        isNormalUser = true;
        description = "Sviatoslav Liashenko";
        extraGroups = [ "networkmanager" "wheel" "audio" "video" "network" ];
        packages = with pkgs; [];
        openssh.authorizedKeys.keys = [
	  "/home/${vars.user}/.ssh/git_ed25519.pub"
        ];
      };
    };
  };

  ### TTY ###
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  ### FONTS ###
  fonts.packages = with pkgs; [
    cm_unicode              # Computer Modern Unicode
    corefonts               # MS bullsh*t
    font-awesome            # FontAwesome
    helvetica-neue-lt-std   # Helvetica Neue (basado)
    noto-fonts              # Noto (basado)
    noto-fonts-cjk
    noto-fonts-emoji

    # Programing
    (nerdfonts.override {
      fonts = [
        "FiraCode"
	"JetBrainsMono"
	"Meslo"
	"SourceCodePro"
	#"Symbols"
      ];
    })
  ];

  ### ENVIRONMENT ###
  environment = {
    variables = {
      TERMINAL = "${vars.terminal}";
      EDITOR = "${vars.editor}";
      VISUAL = "${vars.editor}";

      XDG_CACHE_HOME  = "$HOME/.cache";
      XDG_CONFIG_HOME = "$HOME/.config";
      XDG_DATA_HOME   = "$HOME/.local/share";
      XDG_STATE_HOME  = "$HOME/.local/state";
      XDG_BIN_HOME    = "$HOME/.local/bin";
      #PATH = [ "${XDG_BIN_HOME}" ];
    };
    systemPackages = with pkgs; [
      # Basic CLI tools
      coreutils
      git
      killall
      nano
      neovim
      pciutils
      ranger
      ripgrep
      terminal # see above
      usbutils
      wget
      xdg-utils
      zsh

      # Audio/Video
      alsa-utils
      feh
      linux-firmware
      mpv
      pavucontrol
      pipewire
      pulseaudio
      vlc

      # Apps
      appimage-run
      firefox

      # File Management
      gnome.file-roller
      pcmanfm
      p7zip
      rsync
      unzip
      unrar
      zip
    ];
  };

  #environment.etc = lib.mapAttrs'
  #  (name: value: {
  #    name = "nix/path/${name}";
  #    value.source = value.flake;
  #  }) config.nix.registry;

  ### PROGRAMS ###
  programs = {
    dconf.enable = true;
    git.enable = true;
    zsh.enable = true;
  };

  ### SOUND ###
  hardware.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
    pulse.enable = true;
    jack.enable = true;
  };

  ### OTHER SERVICES ###
  services = {
    # X11 ##
    #xserver = {
    #  #enable = true;
    #  xkb = {
    #    layout = "us,ua,ru";
    #    variant = ",,";
    #    options = "grp:alt_shift_toggle,ctrl:swapcaps";
    #  };
    #};
    ## OpenSSH ##
    openssh = {
      enable = true;
      allowSFTP = true;
      settings = {
        # Forbid root login through SSH.
        PermitRootLogin = "no";
        # Use keys only. Remove if you want to SSH using password (not recommended)
        PasswordAuthentication = false;
      };
    };
  };

  ### NIXPKGS ###
  nixpkgs = {
    config = {
      allowUnfree = true;
      #allowUnfreePredicate = _: true; # https://github.com/nix-community/home-manager/issues/2942
    };
  };

  ### NIX ###
  nix = {
    settings = {
      experimental-features = "nix-command flakes";
      auto-optimise-store = true; # deduplicate and optimize nix store
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 2d";
    };


    # This will add each flake input as a registry
    # To make nix3 commands consistent with your flake
    registry = (lib.mapAttrs (_: flake: {inherit flake;})) ((lib.filterAttrs (_: lib.isType "flake")) inputs);
   
    # This will additionally add your inputs to the system's legacy channels
    # Making legacy nix commands consistent as well, awesome!
    nixPath = ["/etc/nix/path"];

    extraOptions = ''
    '';
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system = {
    autoUpgrade = {
      enable = true;
      channel = "https://nixos.org/channels/nixos-unstable";
    };
    stateVersion = "23.11";
  };

  home-manager.users.${vars.user} ={
    home = {
      stateVersion = "23.11";
    };
    programs = {
      home-manager.enable = true;
    };
    xdg = {
      mime.enable = true;
      mimeApps = {
        enable = true;
	defaultApplications = {
	  "image/png" = [ "feh.desktop" ];
	  "image/jpeg" = [ "feh.desktop" ];
	  "text/plain" = "nvim.desktop";
	  "text/html" = "nvim.desktop";
	  "text/csv" = "nvim.desktop";
	  "application/zip" = "org.gnome.FileRoller.desktop";
	  "application/x-tar" = "org.gnome.FileRoller.desktop";
	  "application/x-bzip2" = "org.gnome.FileRoller.desktop";
	  "application/x-gzip" = "org.gnome.FileRoller.desktop";
	  "x-scheme-handler/http" = [ "firefox.desktop" ];
	  "x-scheme-handler/https" = [ "firefox.desktop" ];
	  "x-scheme-handler/about" = [ "firefox.desktop" ];
	  "x-scheme-handler/unknown" = [ "firefox.desktop" ];
	  "x-scheme-handler/mailto" = [ "gmail.desktop" ];
	  "audio/mp3" = "mpv.desktop";
	  "audio/x-matroska" = "mpv.desktop";
	  "video/webm" = "mpv.desktop";
	  "video/mp4" = "mpv.desktop";
	  "video/x-matroska" = "mpv.desktop";
	  "inode/directory" = "pcmanfm.desktop";
	};
      };
      desktopEntries.gmail = {
        name = "Gmail";
	exec = ''xdg-open "https://mail.google.com/mail/?view=cm&fs=1&to%u"'';
	mimeType = [ "x-scheme-handler/mailto" ];
      };
    };
  };
}

