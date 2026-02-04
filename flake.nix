{
  description = "NixOS + Niri + Noctalia = Heaven on Earth";

  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  inputs = {
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.11";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };

    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };
  };

  outputs =
    {
      self,
      nixpkgs-unstable,
      nixpkgs-stable,
      home-manager,
      noctalia,
      nixvim,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      lib = nixpkgs-stable.lib;
      pkgs = nixpkgs-stable.legacyPackages.${system};

      # Common modules for all configurations
      commonModules = [
        ./configuration.nix
        home-manager.nixosModules.home-manager
      ];

      # Home Manager configuration
      homeManagerConfig = {
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          backupFileExtension = "backup";
          extraSpecialArgs = { 
            inherit inputs;
            inherit (inputs) noctalia;
          };
          users.shinobi = {
            imports = [
              ./home/common.nix
              ./home/zsh.nix
              ./home/niri.nix
            ];
          };
        };
      };
    in
    {
      nixosConfigurations = {
        zenxtsu = lib.nixosSystem {
          inherit system;
          specialArgs = { 
            inherit inputs;
            pkgs-unstable = import nixpkgs-unstable {
              inherit system;
              config.allowUnfree = true;
            };
          };
          modules = commonModules ++ [ homeManagerConfig ];
        };
      };

      # Development shell for working on this configuration
      devShells.${system}.default = pkgs.mkShell {
        buildInputs = with pkgs; [
          nixfmt-rfc-style
          git
          nil # Nix language server
        ];
        shellHook = ''
          echo "╔════════════════════════════════════════════════════════╗"
          echo "║  NixOS Configuration Development Shell                ║"
          echo "╚════════════════════════════════════════════════════════╝"
          echo ""
          echo "Available commands:"
          echo "  nixfmt-rfc-style <file>  - Format Nix files"
          echo "  nix flake check          - Validate flake"
          echo "  nix flake update         - Update dependencies"
          echo "  rebuild                  - Apply configuration (after rebuild)"
          echo ""
          echo "Configuration: zenxtsu"
          echo "Location: $(pwd)"
        '';
      };
    };
}
