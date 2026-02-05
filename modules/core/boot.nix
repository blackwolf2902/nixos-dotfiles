{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.workstation.core.boot;
in
{
  options.workstation.core.boot.enable = lib.mkEnableOption "Bootloader and kernel configuration";

  config = lib.mkIf cfg.enable {
    boot = {
      loader = {
        systemd-boot.enable = true;
        efi.canTouchEfiVariables = true;
      };
      kernelPackages = pkgs.linuxPackages_latest;
      kernelModules = [ "uvcvideo" ];
    };

    hardware.enableAllFirmware = true;
  };
}
