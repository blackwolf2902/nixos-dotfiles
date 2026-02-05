{
  config,
  lib,
  ...
}:
let
  cfg = config.workstation.core.nix-settings;
in
{
  options.workstation.core.nix-settings.enable = lib.mkEnableOption "Nix flakes, optimisation, and garbage collection";

  config = lib.mkIf cfg.enable {
    nix.settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      auto-optimise-store = true;
      trusted-users = [
        "root"
        "shinobi"
      ];
    };

    nix.optimise = {
      automatic = true;
      dates = [ "weekly" ];
    };

    nix.gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 10d";
    };

    nixpkgs.config.allowUnfree = true;
  };
}
