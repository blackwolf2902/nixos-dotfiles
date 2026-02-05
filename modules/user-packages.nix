{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  cfg = config.workstation.user-packages;
in
{
  options.workstation.user-packages = {
    enable = lib.mkEnableOption "User-specific package collections";

    # Development environments
    development = {
      c-cpp.enable = lib.mkEnableOption "C/C++ development tools";
      python.enable = lib.mkEnableOption "Python development tools";
      rust.enable = lib.mkEnableOption "Rust development tools";
      java.enable = lib.mkEnableOption "Java development tools";
      web.enable = lib.mkEnableOption "Web development tools";
    };

    # Application categories
    editors.enable = lib.mkEnableOption "Code editors (VSCode, Zed)";
    browsers.enable = lib.mkEnableOption "Web browsers (Zen, Chrome)";
    media.enable = lib.mkEnableOption "Media applications (VLC, Spotify)";
    productivity.enable = lib.mkEnableOption "Productivity tools (OnlyOffice, Zathura)";
    communication.enable = lib.mkEnableOption "Communication apps (Telegram)";
    database.enable = lib.mkEnableOption "Database tools (DBeaver)";

    # Optional features
    virtualization.enable = lib.mkEnableOption "Virtualization (virt-manager, QEMU)";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs;
      # C/C++ Development
      (lib.optionals cfg.development.c-cpp.enable [
        gcc
        clang
        cmake
        gnumake
        gdb
        valgrind
        pkg-config
      ])
      ++
      # Python Development
      (lib.optionals cfg.development.python.enable [
        python3
        python3Packages.pip
        python3Packages.virtualenv
        uv # Modern Python package manager
        ruff # Python linter/formatter
      ])
      ++
      # Rust Development
      (lib.optionals cfg.development.rust.enable [
        rustup
        cargo
        rustc
        rust-analyzer
        rustfmt
        clippy
      ])
      ++
      # Java Development
      (lib.optionals cfg.development.java.enable [
        jdk
        maven
        gradle
      ])
      ++
      # Web Development
      (lib.optionals cfg.development.web.enable [
        nodejs_22
        nodePackages.npm
        nodePackages.pnpm
        nodePackages.yarn
        nodePackages.typescript
        nodePackages.typescript-language-server
      ])
      ++
      # Code Editors
      (lib.optionals cfg.editors.enable [
        vscode
        zed-editor
        antigravity
      ])
      ++
      # Browsers
      (lib.optionals cfg.browsers.enable [
        inputs.zen-browser.packages.${pkgs.system}.default
        google-chrome
      ])
      ++
      # Media Applications
      (lib.optionals cfg.media.enable [
        vlc
        spotify
      ])
      ++
      # Productivity Tools
      (lib.optionals cfg.productivity.enable [
        onlyoffice-desktopeditors
        zathura
      ])
      ++
      # Communication
      (lib.optionals cfg.communication.enable [
        telegram-desktop
      ])
      ++
      # Database Tools
      (lib.optionals cfg.database.enable [
        dbeaver-bin
      ])
      ++
      # Virtualization (optional)
      (lib.optionals cfg.virtualization.enable [
        virt-manager
        qemu
        OVMF
      ]);

    # Virtualization services (only if enabled)
    programs.virt-manager.enable = lib.mkIf cfg.virtualization.enable true;
    virtualisation = lib.mkIf cfg.virtualization.enable {
      libvirtd = {
        enable = true;
        qemu.swtpm.enable = true;
      };
      spiceUSBRedirection.enable = true;
    };
  };
}
