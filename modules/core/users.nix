{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.workstation.core.users;
in
{
  options.workstation.core.users.enable = lib.mkEnableOption "User accounts and auto-login";

  config = lib.mkIf cfg.enable {
    users.users.shinobi = {
      isNormalUser = true;
      shell = pkgs.zsh;
      extraGroups = [
        "wheel"
        "networkmanager"
        "sound"
        "video"
        "audio"
      ] ++ lib.optionals config.workstation.user-packages.virtualization.enable [ "libvirtd" ];
    };

    services.displayManager.autoLogin = {
      enable = true;
      user = "shinobi";
    };

    systemd.services."autovt@tty1".enable = false;
    systemd.services."getty@tty1".enable = false;
  };
}
