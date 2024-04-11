{ vars, ... }: {
  config = {
    home-manager.users.${vars.user} = {
      ## Git ##
      programs.git = {
        enable = true;
        userName = "Sviatoslav Liashenko";
        userEmail = "sweathrtx@gmail.com";
      };
    };
  };
}
