# Quick Reference - ZenXtsu NixOS Configuration

## Build Commands

```bash
# Navigate to config directory
cd /home/shinobi/Downloads/nixos

# Test build (doesn't apply changes)
sudo nixos-rebuild build --flake .#zenxtsu --impure

# Apply configuration
sudo nixos-rebuild switch --flake .#zenxtsu --impure

# Update flake inputs
nix flake update
```

## Enable/Disable Features

Edit `configuration.nix`:

```nix
workstation.user-packages = {
  enable = true;
  
  # Toggle development environments
  development = {
    c-cpp.enable = true;    # C/C++ tools
    python.enable = true;   # Python
    rust.enable = true;     # Rust
    java.enable = true;     # Java
    web.enable = true;      # Node.js, npm
  };
  
  # Toggle applications
  editors.enable = true;        # VSCode, Zed
  browsers.enable = true;       # Zen, Chrome
  media.enable = true;          # VLC, Spotify
  productivity.enable = true;   # OnlyOffice, Zathura
  communication.enable = true;  # Telegram
  database.enable = true;       # DBeaver
  
  # Optional features
  virtualization.enable = false; # virt-manager (disabled by default)
};
```

## Add Quick Packages

Add to `configuration.nix` after imports:

```nix
environment.systemPackages = with pkgs; [
  your-package-name
];
```

## System Info

- **Hostname**: zenxtsu
- **User**: shinobi
- **Desktop**: Niri + Noctalia Shell
- **Shell**: Zsh with Oh-My-Zsh
- **Terminal**: Ghostty
- **Theme**: Tokyo Night

## Useful Aliases

- `ls` → eza (better ls)
- `yz` → yazi (TUI file manager)
- `lg` → lazygit

## Cleanup

```bash
# Remove old generations
nix-collect-garbage -d

# Remove generations older than 7 days (automatic weekly)
```

## Documentation

- [README.md](./README.md) - Full setup guide
- [PACKAGE_GUIDE.md](./PACKAGE_GUIDE.md) - Package management details
