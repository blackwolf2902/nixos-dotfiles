# System Rollback Guide

## Rollback at boot
- Reboot and select previous generation from systemd-boot menu

## Rollback from running system
```bash
# List generations
sudo nix-env --list-generations --profile /nix/var/nix/profiles/system

# Rollback to previous
sudo nixos-rebuild switch --rollback

# Rollback to specific generation
sudo /nix/var/nix/profiles/system-42-link/bin/switch-to-configuration switch
```

## After successful testing
```bash
# Delete old generations older than 7 days
sudo nix-collect-garbage --delete-older-than 7d
```