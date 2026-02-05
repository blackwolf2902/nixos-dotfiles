{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.workstation.services.flatpak;
in
{
  options.workstation.services.flatpak.enable = lib.mkEnableOption "Flatpak with Flathub repository";

  config = lib.mkIf cfg.enable {
    services.flatpak.enable = true;

    systemd.services.flatpak-repo = {
      wantedBy = [ "multi-user.target" ];
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      path = [ pkgs.flatpak ];
      script = ''
        flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
      '';
    };
  };
}
