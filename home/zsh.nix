{
  config,
  pkgs,
  lib,
  ...
}:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    autocd = true;
    shellAliases = {
      ls = "eza";
      battery-health = "upower -i /org/freedesktop/UPower/devices/battery_BAT0";
      yz = "yazi";
      lg = "lazygit";
    };
    initContent = lib.mkMerge [
      (lib.mkOrder 1000 ''
        export EZA_CONFIG_DIR="$HOME/.config/eza"
        export EZA_ICONS_AUTO=1
      '')
      (lib.mkOrder 1500 ''
        eval "$(${pkgs.starship}/bin/starship init zsh)"
      '')
    ];
    history.size = 10000;
    oh-my-zsh = {
      enable = true;
      package = pkgs.oh-my-zsh;
      plugins = [ "autojump" ];
    };
  };
}
