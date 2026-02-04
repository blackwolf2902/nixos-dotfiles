# Hardware Configuration

## Overview

This repository includes a **minimal dummy `hardware-configuration.nix`** for CI/CD validation purposes. On your actual system, you should use the real hardware configuration from `/etc/nixos/`.

## For CI/CD (Garnix, Hydra, etc.)

The included `hardware-configuration.nix` is a minimal dummy file that allows CI systems to validate the flake without requiring actual hardware. It contains:
- Generic kernel modules
- Dummy filesystem UUIDs
- Basic Intel CPU configuration

This ensures your configuration can be validated before deployment.

## For Your Actual System

### Option 1: Use /etc/nixos/hardware-configuration.nix (Recommended)

The flake is configured to use `/etc/nixos/hardware-configuration.nix` by default when building with `--impure`:

```bash
# Build the configuration
sudo nixos-rebuild build --flake .#zenxtsu --impure

# Apply the configuration
sudo nixos-rebuild switch --flake .#zenxtsu --impure
```

The `--impure` flag allows Nix to access the real hardware configuration from `/etc/nixos/`.

### Option 2: Replace the dummy file

Alternatively, you can replace the dummy `hardware-configuration.nix` in this repo with your actual one:

```bash
# Copy your real hardware config
sudo cp /etc/nixos/hardware-configuration.nix /home/shinobi/Downloads/nixos/

# Build without --impure flag
sudo nixos-rebuild build --flake .#zenxtsu
```

**Note:** If you do this, don't commit your real hardware config to the public repo if it contains sensitive information.

## Generating Your Hardware Configuration

If you need to generate a new hardware configuration:

```bash
# Generate and place in /etc/nixos/
sudo nixos-generate-config

# This creates /etc/nixos/hardware-configuration.nix
```

Or during NixOS installation:

```bash
# Boot from NixOS installer
# Generate hardware config
sudo nixos-generate-config --root /mnt

# This will create /mnt/etc/nixos/hardware-configuration.nix
```

## What This File Contains

The hardware configuration includes:
- Boot loader settings
- File system mounts and UUIDs
- Kernel modules for your specific hardware
- CPU microcode settings
- Network interfaces
- Swap configuration

This file is unique to your hardware.
