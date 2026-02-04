{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.workstation.laptop-hardware;
in
{
  options.workstation.laptop-hardware.enable = lib.mkEnableOption "Laptop-specific hardware optimizations";

  config = lib.mkIf cfg.enable {
    # Battery optimization with TLP
    services.tlp = {
      enable = true;
      settings = {
        # CPU settings
        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
        
        # CPU boost
        CPU_BOOST_ON_AC = 1;
        CPU_BOOST_ON_BAT = 0;
        
        # CPU energy/performance policy
        CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
        CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
        
        # Battery thresholds (helps preserve battery life)
        START_CHARGE_THRESH_BAT0 = 40;
        STOP_CHARGE_THRESH_BAT0 = 80;
        
        # Runtime power management
        RUNTIME_PM_ON_AC = "on";
        RUNTIME_PM_ON_BAT = "auto";
        
        # USB autosuspend
        USB_AUTOSUSPEND = 1;
        
        # WiFi power saving
        WIFI_PWR_ON_AC = "off";
        WIFI_PWR_ON_BAT = "on";
      };
    };

    # Touchpad configuration
    services.libinput = {
      enable = true;
      touchpad = {
        tapping = true;
        naturalScrolling = true;
        disableWhileTyping = true;
        clickMethod = "clickfinger";
        accelProfile = "adaptive";
        accelSpeed = "0.5";
      };
    };

    # Power management
    powerManagement = {
      enable = true;
      cpuFreqGovernor = "powersave";
    };

    # Thermald for Intel thermal management
    services.thermald.enable = true;

    # Auto-cpufreq as alternative (disabled by default, conflicts with TLP)
    # services.auto-cpufreq.enable = false;
  };
}
