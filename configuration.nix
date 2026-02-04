{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    /etc/nixos/hardware-configuration.nix
    ./modules/baseline.nix
    ./modules/niri.nix
    ./modules/laptop-hardware.nix
    ./modules/user-packages.nix
    ./modules/nixvim.nix
  ];

  # Hostname
  networking.hostName = "zenxtsu";

  # Intel CPU microcode updates
  hardware.cpu.intel.updateMicrocode = true;

  # Enable workstation modules
  workstation = {
    baseline.enable = true;
    niri.enable = true;
    nixvim.enable = true;
    laptop-hardware.enable = true;
    user-packages = {
      enable = true;
      # Development environments
      development = {
        c-cpp.enable = true;
        python.enable = true;
        rust.enable = true;
        java.enable = true;
        web.enable = true;
      };
      # Applications
      editors.enable = true;
      browsers.enable = true;
      media.enable = true;
      productivity.enable = true;
      communication.enable = true;
      database.enable = true;
      # Optional features
      virtualization.enable = false; # Set to true when needed
    };
  };
}
