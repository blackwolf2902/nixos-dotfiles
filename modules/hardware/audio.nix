{
  config,
  lib,
  ...
}:
let
  cfg = config.workstation.hardware.audio;
in
{
  options.workstation.hardware.audio.enable = lib.mkEnableOption "PipeWire audio with low-latency support";

  config = lib.mkIf cfg.enable {
    # RTKit for real-time scheduling (low-latency audio)
    security.rtkit.enable = true;

    services.pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
      jack.enable = true;
      wireplumber.enable = true;
    };
  };
}
