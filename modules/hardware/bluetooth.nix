{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.workstation.hardware.bluetooth;
in
{
  options.workstation.hardware.bluetooth.enable = lib.mkEnableOption "Bluetooth support with blueman";

  config = lib.mkIf cfg.enable {
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
      settings = {
        General = {
          Experimental = true;
          FastConnectable = false;
        };
        Policy = {
          AutoEnable = true;
        };
      };
    };

    environment.systemPackages = [ pkgs.blueman ];
  };
}
