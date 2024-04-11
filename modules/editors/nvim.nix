{ pkgs, inputs, vars, ... }: {
  environment = {
    systemPackages = with pkgs; [
      lua
      nodejs
      nodePackages.npm
      python3
    ];
  };

  home-manager.users.${vars.user} = {
    #home.file = {
    #  ".config/nvim" = {
    #    source = ./nvim;
    #          target = ".config/nvim";
    #  };
    #};

    programs.neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;

      plugins = with pkgs; [
        vimPlugins.lazy-nvim
      ];
    };
  };
}
