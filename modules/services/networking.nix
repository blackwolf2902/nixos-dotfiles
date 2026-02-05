{
  config,
  lib,
  ...
}:
let
  cfg = config.workstation.services.networking;
in
{
  options.workstation.services.networking.enable = lib.mkEnableOption "NetworkManager and Tailscale";

  config = lib.mkIf cfg.enable {
    networking.networkmanager.enable = true;

    services.tailscale.enable = true;
  };
}
