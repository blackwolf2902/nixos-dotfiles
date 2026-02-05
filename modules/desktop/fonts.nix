{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.workstation.desktop.fonts;
in
{
  options.workstation.desktop.fonts.enable = lib.mkEnableOption "System fonts and fontconfig";

  config = lib.mkIf cfg.enable {
    fonts = {
      enableDefaultPackages = true;
      packages = with pkgs; [
        nerd-fonts.jetbrains-mono
        inter
      ];
      fontconfig = {
        enable = true;
        defaultFonts = {
          sansSerif = [
            "Inter"
            "Noto Sans"
          ];
          serif = [ "Noto Serif" ];
          monospace = [ "JetBrainsMono Nerd Font" ];
        };
      };
      fontDir.enable = true;
    };
  };
}
