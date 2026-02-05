{
  config,
  lib,
  ...
}:
let
  cfg = config.workstation.hardware.power;
in
{
  options.workstation.hardware.power.enable = lib.mkEnableOption "TLP and thermald power management for laptops";

  config = lib.mkIf cfg.enable {
    services.tlp = {
      enable = true;
      settings = {
        # CPU Governor
        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

        # Intel CPU energy policy
        CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
        CPU_ENERGY_PERF_POLICY_ON_BAT = "power";

        # Battery charge thresholds (preserve battery health)
        START_CHARGE_THRESH_BAT0 = 40;
        STOP_CHARGE_THRESH_BAT0 = 80;

        # Platform profile
        PLATFORM_PROFILE_ON_AC = "performance";
        PLATFORM_PROFILE_ON_BAT = "low-power";
      };
    };

    # Intel thermal management daemon
    services.thermald.enable = true;
  };
}
