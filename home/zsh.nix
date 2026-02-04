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
      rebuild = "sudo nixos-rebuild switch --flake /home/shinobi/Downloads/nixos#zenxtsu";
      rebuild-test = "sudo nixos-rebuild test --flake /home/shinobi/Downloads/nixos#zenxtsu";
    };
    initExtra = ''
      export EZA_CONFIG_DIR="$HOME/.config/eza"
      export EZA_ICONS_AUTO=1
      eval "$(${pkgs.starship}/bin/starship init zsh)"
    '';
    history = {
      size = 10000;
      path = "$HOME/.zsh_history";
    };
    oh-my-zsh = {
      enable = true;
      package = pkgs.oh-my-zsh;
      plugins = [
        "autojump"
        "git"
      ];
    };
  };
}
