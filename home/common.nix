{
  config,
  pkgs,
  lib,
  ...
}:

{

  home = {
    username = "shinobi";
    homeDirectory = "/home/shinobi";
    stateVersion = "25.11";
  };
  
  programs.home-manager.enable = true;
  programs.git = {
      enable = true;
      package = pkgs.git;
      settings = {
          core.editor = "nvim";
      };
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.btop = {
    enable = true;
    settings = {
      color_theme = "tokyo-night";
      theme_background = true;
      truecolor = true;
    };
  };

  xdg.configFile = {
    "starship.toml".source = ../config/starship/starship.main.toml;
    "ghostty/config".source = ../config/ghostty/tokyo-night.ghostty;
    "eza/theme.yml".source = ../config/eza/eza.main.yml;
    "fastfetch/config.jsonc".source = ../config/fastfetch/main.fastfetch;
    "fastfetch/nezuko.png".source = ../config/icons/nezuko.png;
  };
}
