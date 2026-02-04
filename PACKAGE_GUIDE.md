# Package Management Guide

This guide explains how to add, remove, and organize packages in your NixOS configuration.

## 📋 Table of Contents

1. [Quick Package Addition](#quick-package-addition)
2. [Using the Modular System](#using-the-modular-system)
3. [Creating Custom Categories](#creating-custom-categories)
4. [Managing Package Versions](#managing-package-versions)
5. [Common Scenarios](#common-scenarios)

## Quick Package Addition

### Method 1: Direct Addition to configuration.nix

For one-off packages, add directly to `configuration.nix`:

```nix
{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  imports = [ ... ];

  # Add your packages here
  environment.systemPackages = with pkgs; [
    htop
    neofetch
    # Add more packages
  ];

  # Rest of configuration...
}
```

### Method 2: Using the Modular System

Enable/disable entire categories in `configuration.nix`:

```nix
workstation.user-packages = {
  enable = true;
  
  # Development environments
  development = {
    c-cpp.enable = true;      # C/C++ tools
    python.enable = true;     # Python tools
    rust.enable = true;       # Rust toolchain
    java.enable = false;      # Disable Java (example)
    web.enable = true;        # Node.js, npm, etc.
  };
  
  # Applications
  editors.enable = true;      # VSCode, Zed
  browsers.enable = true;     # Zen, Chrome
  media.enable = true;        # VLC, Spotify
  productivity.enable = true; # OnlyOffice, Zathura
  communication.enable = true;# Telegram
  database.enable = true;     # DBeaver
  
  # Optional features
  virtualization.enable = false; # Enable when needed
};
```

## Using the Modular System

### Adding Packages to Existing Categories

Edit `modules/user-packages.nix`:

```nix
# Example: Adding Discord to communication category
(lib.optionals cfg.communication.enable [
  telegram-desktop
  discord  # Add this line
])
```

### Removing Packages from Categories

Simply comment out or remove the package:

```nix
# Example: Removing Spotify from media
(lib.optionals cfg.media.enable [
  vlc
  # spotify  # Commented out
])
```

## Creating Custom Categories

### Step 1: Add Option Definition

In `modules/user-packages.nix`, add to the `options` section:

```nix
options.workstation.user-packages = {
  enable = lib.mkEnableOption "User-specific package collections";

  # ... existing options ...

  # Add your new category
  gaming.enable = lib.mkEnableOption "Gaming applications";
};
```

### Step 2: Add Package List

In the `config` section, add your packages:

```nix
config = lib.mkIf cfg.enable {
  environment.systemPackages = with pkgs;
    # ... existing categories ...
    ++
    # Gaming (your new category)
    (lib.optionals cfg.gaming.enable [
      steam
      lutris
      heroic
      mangohud
    ])
    ++
    # ... rest of categories ...
};
```

### Step 3: Enable in configuration.nix

```nix
workstation.user-packages = {
  enable = true;
  gaming.enable = true;  # Enable your new category
  # ... other categories ...
};
```

## Managing Package Versions

### Using Stable vs Unstable

By default, packages come from unstable. To use stable versions:

1. **Edit flake.nix** to expose stable packages:

```nix
outputs = { self, nixpkgs-unstable, nixpkgs-stable, ... }@inputs:
  let
    system = "x86_64-linux";
    pkgs-stable = import nixpkgs-stable {
      inherit system;
      config.allowUnfree = true;
    };
  in {
    nixosConfigurations.zenxtsu = lib.nixosSystem {
      specialArgs = { 
        inherit inputs; 
        pkgs-stable = pkgs-stable;  # Add this
      };
      # ... rest of config
    };
  };
```

2. **Use in modules**:

```nix
{ config, lib, pkgs, pkgs-stable, ... }:

{
  environment.systemPackages = with pkgs; [
    firefox  # From unstable
  ] ++ [
    pkgs-stable.chromium  # From stable
  ];
}
```

### Pinning Specific Versions

For specific package versions, use overlays or direct derivation references.

## Common Scenarios

### Scenario 1: Adding a Single Package

**Quick way** - Edit `configuration.nix`:

```nix
environment.systemPackages = with pkgs; [
  gimp  # Add your package
];
```

**Organized way** - Add to appropriate category in `modules/user-packages.nix`.

### Scenario 2: Adding Development Tools

Enable the relevant development category:

```nix
# In configuration.nix
workstation.user-packages = {
  development = {
    go.enable = true;  # If you add Go category
  };
};
```

Then add Go category to `modules/user-packages.nix`:

```nix
# Add option
development = {
  # ... existing ...
  go.enable = lib.mkEnableOption "Go development tools";
};

# Add packages
(lib.optionals cfg.development.go.enable [
  go
  gopls
  gotools
])
```

### Scenario 3: Temporary Package Testing

Use `nix-shell` for temporary testing:

```bash
# Test a package without installing
nix-shell -p package-name

# Test multiple packages
nix-shell -p package1 package2
```

### Scenario 4: Removing Unwanted Categories

Disable in `configuration.nix`:

```nix
workstation.user-packages = {
  database.enable = false;  # Don't need DBeaver
};
```

### Scenario 5: System-Wide vs User Packages

**System-wide** (available to all users):
- Add to `environment.systemPackages` in any module

**User-specific** (via Home Manager):
- Add to `home/common.nix`:

```nix
home.packages = with pkgs; [
  personal-package
];
```

## 🔍 Finding Packages

### Search NixOS Packages

```bash
# Search for a package
nix search nixpkgs package-name

# Example
nix search nixpkgs firefox
```

### Online Search

Visit [search.nixos.org](https://search.nixos.org/packages) for a web interface.

## 🧹 Cleanup

### Remove Unused Packages

After disabling categories, clean up:

```bash
# Rebuild to remove packages
sudo nixos-rebuild switch --flake .#zenxtsu

# Garbage collect
nix-collect-garbage -d
```

## 💡 Best Practices

1. **Use categories** for related packages
2. **Keep configuration.nix clean** - use modules for organization
3. **Document custom categories** with comments
4. **Test changes** with `nixos-rebuild build` before `switch`
5. **Commit changes** to version control regularly

## 📚 Additional Resources

- [NixOS Package Search](https://search.nixos.org/packages)
- [Nix Package Manager Manual](https://nixos.org/manual/nix/stable/)
- [NixOS Options Search](https://search.nixos.org/options)
