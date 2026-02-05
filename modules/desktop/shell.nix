{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.workstation.desktop.shell;
in
{
  options.workstation.desktop.shell.enable = lib.mkEnableOption "Zsh and shell environment";

  config = lib.mkIf cfg.enable {
    programs.zsh.enable = true;
    programs.dconf.enable = true;
    programs.firefox.enable = true;

    environment.pathsToLink = [ "/share/zsh" ];

    environment.systemPackages = with pkgs; [
      oh-my-zsh
      autojump
      starship
      fastfetch
    ];
  };
}
