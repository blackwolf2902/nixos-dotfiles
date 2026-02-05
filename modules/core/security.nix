{
  config,
  lib,
  ...
}:
let
  cfg = config.workstation.core.security;
in
{
  options.workstation.core.security.enable = lib.mkEnableOption "Basic security hardening";

  config = lib.mkIf cfg.enable {
    # Firewall
    networking.firewall.enable = true;

    # SSH hardening (only applies if SSH is enabled elsewhere)
    services.openssh.settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
      KbdInteractiveAuthentication = false;
    };

    # Kernel hardening via sysctl
    boot.kernel.sysctl = {
      # Hide kernel pointers from unprivileged users
      "kernel.kptr_restrict" = 2;
      # Restrict dmesg to root
      "kernel.dmesg_restrict" = 1;
      # Harden BPF JIT
      "net.core.bpf_jit_harden" = 2;
      # Disable SysRq key
      "kernel.sysrq" = 0;
      # Protect hardlinks and symlinks
      "fs.protected_hardlinks" = 1;
      "fs.protected_symlinks" = 1;
    };
  };
}
