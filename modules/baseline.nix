{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  cfg = config.workstation.baseline;
in
{
  options.workstation.baseline.enable = lib.mkEnableOption "Baseline workstation configuration";

  config = lib.mkIf cfg.enable {
    nix.settings.experimental-features = [
      "nix-command"
      "flakes"
    ];

    nixpkgs.config.allowUnfree = true;

    boot = {
      loader = {
        systemd-boot.enable = true;
        efi.canTouchEfiVariables = true;
      };
      kernelPackages = pkgs.linuxPackages_latest;
      kernelModules = [ "uvcvideo" ];
    };

    hardware.enableAllFirmware = true;
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        intel-media-driver
        intel-vaapi-driver
      ];
    };

    networking.networkmanager.enable = true;

    nix.gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };

    time.timeZone = "Asia/Kolkata";

    i18n.defaultLocale = "en_US.UTF-8";
    console = {
      font = "Lat2-Terminus16";
      keyMap = "us";
    };

    users.users.shinobi = {
      isNormalUser = true;
      shell = pkgs.zsh;
      extraGroups = [
        "wheel"
        "networkmanager"
        "sound"
        "video"
        "audio"
  ] ++ lib.optionals config.workstation.user-packages.virtualization.enable [ "libvirtd" ];    };

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

    # Auto-login configuration for Niri
    services.displayManager.autoLogin = {
      enable = true;
      user = "shinobi";
    };

    # Disable getty on tty1 for auto-login to work properly
    systemd.services."autovt@tty1".enable = false;
    systemd.services."getty@tty1".enable = false;

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
    
    programs.firefox.enable = true;
    programs.dconf.enable = true;
    
    programs.zsh.enable = true;
    environment.pathsToLink = [ "/share/zsh" ];

    environment.systemPackages = with pkgs; [
      # Core system tools
      wget
      git
      htop
      curl
      tree
      eza
      ghostty
      fastfetch
      starship
      nixfmt-rfc-style
      blueman
      ffmpeg
      whois
      parted
      usbutils
      smartmontools
      pciutils
      file
      dig
      oh-my-zsh
      autojump
      screen
      #utils
      lazygit
      # File managers
      nemo
      yazi
    ];

    services = {
      tailscale.enable = true;
      # pcscd.enable = true; # yubikey dep - disabled, no yubikey
      libinput.enable = true;
      upower.enable = true;
      power-profiles-daemon.enable = false; # conflicts with TLP, use it as per need
      pipewire = {
        enable = true;
        pulse.enable = true;
        alsa.enable = true;
      };
    };

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

    system.stateVersion = "25.11";
  };
}
