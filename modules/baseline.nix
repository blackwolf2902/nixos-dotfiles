{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.workstation.baseline;
in
{
  imports = [
    # Core
    ./core/nix-settings.nix
    ./core/boot.nix
    ./core/users.nix
    ./core/security.nix
    # Hardware
    ./hardware/graphics.nix
    ./hardware/bluetooth.nix
    ./hardware/audio.nix
    ./hardware/power.nix
    # Desktop
    ./desktop/fonts.nix
    ./desktop/shell.nix
    # Services
    ./services/networking.nix
    ./services/flatpak.nix
  ];

  options.workstation.baseline.enable = lib.mkEnableOption "Baseline workstation configuration";

  config = lib.mkIf cfg.enable {
    # Enable all submodules by default when baseline is enabled
    workstation.core.nix-settings.enable = lib.mkDefault true;
    workstation.core.boot.enable = lib.mkDefault true;
    workstation.core.users.enable = lib.mkDefault true;
    workstation.core.security.enable = lib.mkDefault true;

    workstation.hardware.graphics.enable = lib.mkDefault true;
    workstation.hardware.bluetooth.enable = lib.mkDefault true;
    workstation.hardware.audio.enable = lib.mkDefault true;
    workstation.hardware.power.enable = lib.mkDefault true;

    workstation.desktop.fonts.enable = lib.mkDefault true;
    workstation.desktop.shell.enable = lib.mkDefault true;

    workstation.services.networking.enable = lib.mkDefault true;
    workstation.services.flatpak.enable = lib.mkDefault true;

    # Locale and timezone
    time.timeZone = "Asia/Kolkata";
    i18n.defaultLocale = "en_US.UTF-8";
    console = {
      font = "Lat2-Terminus16";
      keyMap = "us";
    };

    # Input and power services
    services.libinput.enable = true;
    services.upower.enable = true;
    services.power-profiles-daemon.enable = false;

    # Core system tools
    environment.systemPackages = with pkgs; [
      wget
      git
      btop
      curl
      tree
      eza
      ghostty
      nixfmt-rfc-style
      ffmpeg
      whois
      parted
      usbutils
      smartmontools
      pciutils
      file
      dig
      screen
      lazygit
      nemo
      yazi
    ];

    # System information
    environment.etc."nixos-info".text = ''
      ╔════════════════════════════════════════════════════════╗
      ║              NixOS System Information                  ║
      ╚════════════════════════════════════════════════════════╝
      
      Configuration: zenxtsu
      User: shinobi
      Desktop: Niri + Noctalia Shell
      Package Source: NixOS 25.11 (stable)
      
      Quick Commands:
        - rebuild: Apply configuration changes
        - rebuild-test: Test configuration without switching
        - nix flake update: Update all inputs
        - cat /etc/nixos-info: Show this information
    '';

    system.stateVersion = "25.11";
  };
}
