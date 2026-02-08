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
      
      # Better rebuild commands
      rebuild = "sudo nixos-rebuild switch --flake /home/shinobi/Downloads/nixos#zenxtsu";
      rebuild-test = "sudo nixos-rebuild test --flake /home/shinobi/Downloads/nixos#zenxtsu";
      rebuild-boot = "sudo nixos-rebuild boot --flake /home/shinobi/Downloads/nixos#zenxtsu";
      rebuild-dry = "sudo nixos-rebuild dry-build --flake /home/shinobi/Downloads/nixos#zenxtsu";
      
      # Flake management  
      update = "nix flake update /home/shinobi/Downloads/nixos";
      check = "nix flake check /home/shinobi/Downloads/nixos";
      
      # Cleanup
      cleanup = "sudo nix-collect-garbage --delete-older-than 7d && nix-collect-garbage --delete-older-than 7d";
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
    programs.direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    }
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
