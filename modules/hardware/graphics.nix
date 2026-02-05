{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.workstation.hardware.graphics;
in
{
  options.workstation.hardware.graphics.enable = lib.mkEnableOption "Intel GPU and VA-API drivers";

  config = lib.mkIf cfg.enable {
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        intel-media-driver
        intel-vaapi-driver
      ];
    };
  };
}
