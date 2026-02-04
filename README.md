# ZenXtsu - NixOS Configuration

Clean, modular NixOS configuration for a single laptop running **Niri + Noctalia Shell**.

## 🖥️ System Information

- **Hostname**: zenxtsu
- **User**: shinobi
- **Desktop**: Niri with Noctalia Shell
- **Hardware**: Lenovo IdeaPad 81VD (Intel i3 7th gen, 8GB RAM)
- **Channel**: NixOS Unstable (with stable packages where applicable)

## 📁 Repository Structure

```
nixos/
├── flake.nix                    # Flake configuration
├── configuration.nix            # Main system configuration
├── hardware-configuration.nix   # Hardware-specific config (auto-generated)
├── modules/
│   ├── baseline.nix            # Core system packages and settings
│   ├── niri.nix                # Niri window manager configuration
│   ├── laptop-hardware.nix     # Laptop optimizations (battery, touchpad)
│   ├── user-packages.nix       # Modular user packages
│   └── nixvim.nix              # Neovim configuration
├── home/
│   ├── common.nix              # Common home-manager settings
│   ├── zsh.nix                 # Zsh shell configuration
│   └── niri.nix                # Niri home-manager settings
└── config/                      # Application config files
```

## 🚀 Quick Start

### First-Time Setup

1. **Clone this repository** (or use your existing copy):
   ```bash
   cd /home/shinobi/Downloads/nixos
   ```

2. **Ensure hardware-configuration.nix exists**:
   - This file should already be present at the root
   - If not, generate it: `nixos-generate-config --show-hardware-config > hardware-configuration.nix`

3. **Review and customize** `configuration.nix`:
   - Enable/disable package categories as needed
   - Toggle optional features like virtualization

4. **Build the configuration**:
   ```bash
   sudo nixos-rebuild build --flake .#zenxtsu
   ```

5. **Apply the configuration**:
   ```bash
   sudo nixos-rebuild switch --flake .#zenxtsu
   ```

### Updating the System

```bash
# Update flake inputs
nix flake update

# Rebuild with new configuration
sudo nixos-rebuild switch --flake .#zenxtsu
```

## 📦 Package Management

This configuration uses a **modular package system** that makes it easy to add or remove software.

### Enabled by Default

All package categories in `configuration.nix` are enabled by default:

- **Development**: C/C++, Python, Rust, Java, Web (Node.js)
- **Editors**: VSCode, Zed
- **Browsers**: Zen Browser, Google Chrome
- **Media**: VLC, Spotify
- **Productivity**: OnlyOffice, Zathura
- **Communication**: Telegram
- **Database**: DBeaver

### Optional Features

**Virtualization** is disabled by default. To enable:

```nix
# In configuration.nix
workstation.user-packages = {
  virtualization.enable = true;  # Change to true
};
```

### Adding New Packages

See [PACKAGE_GUIDE.md](./PACKAGE_GUIDE.md) for detailed instructions.

## ⚙️ Key Features

### Laptop Optimizations

- **TLP**: Intelligent battery management
- **Touchpad**: Natural scrolling, tap-to-click, palm rejection
- **Thermal Management**: Intel thermald for temperature control
- **Power Profiles**: Automatic switching between AC and battery

### Desktop Environment

- **Niri**: Scrollable tiling Wayland compositor
- **Noctalia Shell**: Modern shell for Niri
- **Tuigreet**: Minimal login manager with autologin
- **Theme**: Tokyo Night (GTK + terminal)

### Development Setup

- **Shell**: Zsh with Oh-My-Zsh
- **Terminal**: Ghostty
- **Editor**: Neovim (via nixvim)
- **Version Control**: Git with core.editor set to nvim

## 🔧 Customization

### Changing Timezone

Edit `modules/baseline.nix`:
```nix
time.timeZone = "Asia/Kolkata";  # Change as needed
```

### Changing Username

1. Update `modules/baseline.nix` (users.users section)
2. Update `modules/niri.nix` (greetd initial_session)
3. Update `home/common.nix` (home.username and homeDirectory)
4. Update `flake.nix` (home-manager.users section)

### Adding Custom Packages

Quick method - add to `configuration.nix`:
```nix
environment.systemPackages = with pkgs; [
  your-package-here
];
```

Organized method - see [PACKAGE_GUIDE.md](./PACKAGE_GUIDE.md)

## 🐛 Troubleshooting

### Build Fails

```bash
# Check for syntax errors
nix flake check

# View detailed error output
sudo nixos-rebuild build --flake .#zenxtsu --show-trace
```

### Package Not Found

Some packages may be in unstable only. Check:
```bash
nix search nixpkgs package-name
```

### Garbage Collection

Free up disk space:
```bash
# Remove old generations (older than 7 days happens automatically)
nix-collect-garbage -d

# Remove specific generations
nix-env --delete-generations 14d
nix-collect-garbage
```

## 📚 Resources

- [NixOS Manual](https://nixos.org/manual/nixos/stable/)
- [Home Manager Manual](https://nix-community.github.io/home-manager/)
- [Niri Documentation](https://github.com/YaLTeR/niri)
- [Noctalia Shell](https://github.com/noctalia-dev/noctalia-shell)

## 💝 Support NixOS

Please consider [sponsoring NixOS](https://github.com/sponsors/NixOS) to support the amazing people behind this project.

## 📝 License

This configuration is provided as-is for personal use. Modify as needed for your setup.