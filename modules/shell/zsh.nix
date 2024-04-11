{ pkgs, config, vars, ... }:
let
  dataHome = config.home-manager.users.${vars.user}.xdg.dataHome;
in {
  users.users.${vars.user} = {
    shell = pkgs.zsh;
  };

  home-manager.users.${vars.user} = {
    ## Zsh ##
    programs.zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;

      history = {
        size = 10000;
	path = "${dataHome}/zsh/history";
      };
      dotDir = ".config/zsh";
    };
  };
}
