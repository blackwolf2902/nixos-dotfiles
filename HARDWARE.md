# Hardware Configuration

The `hardware-configuration.nix` file is **not included** in this repository as it's hardware-specific and auto-generated.

## Location

This configuration expects `hardware-configuration.nix` to be located at:
```
/etc/nixos/hardware-configuration.nix
```

The `configuration.nix` imports it from this absolute path, so you can work on your dotfiles repo without including hardware-specific settings.

## Generating Your Hardware Configuration

If you don't have it yet, generate your hardware configuration:

```bash
# Generate and place in /etc/nixos/
sudo nixos-generate-config

# This creates /etc/nixos/hardware-configuration.nix
```

Or if you're migrating from Fedora:

```bash
# Boot from NixOS installer
# Generate hardware config
sudo nixos-generate-config --root /mnt

# This will create /mnt/etc/nixos/hardware-configuration.nix
```

## What This File Contains

The hardware configuration includes:
- Boot loader settings
- File system mounts
- Kernel modules for your specific hardware
- CPU microcode settings
- Network interfaces
- Swap configuration

This file is unique to your hardware and stays in `/etc/nixos/` on your system.
