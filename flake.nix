{
  description = "My nix configuration for nixos and Home Manager";

  nixConfig = {
    extra-substituters = [
      "https://pbcdev.cachix.org"
      "https://cache.nixos.org"
      "https://nix-community.cachix.org"
      "https://niri.cachix.org"
      "https://doom-emacs-unstraightened.cachix.org"
      "https://nyx-cache.chaotic.cx"
    ];

    extra-trusted-public-keys = [
      "pbcdev.cachix.org-1:iZbrMY/10HM5BQPXeIIHkGoDc4boLuSZYiZuPhIn9P8="
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964="
      "doom-emacs-unstraightened.cachix.org-1:O5oOlRPnmQEvVaFyuMTmthCEooHbrg54WgSLR07tmg4="
      "nyx-cache.chaotic.cx:dJxTrgMC3V3cFfyIiBQDQorG6k1LsqurH/srpMSq7qk="
    ];
    allow-unfree = true;
    auto-optimise-store = true;
  };

  outputs =
    inputs@{ flake-parts
    , ...
    }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" ];
      imports = [
        inputs.treefmt-nix.flakeModule
      ];

      perSystem = { pkgs, ... }: {
        treefmt.config = {
          projectRootFile = "flake.nix";
          programs = {
            nixpkgs-fmt.enable = true;
            prettier.enable = true;
          };
        };

        packages = import ./packages { inherit pkgs; };
        devShells.default = import ./modules/devshell.nix { inherit pkgs; };
      };

      flake =
        let
          extraModulesHome = with inputs; [
            plasma-manager.homeModules.plasma-manager
            niri.homeModules.niri
            niri.homeModules.stylix
            stylix.homeModules.stylix
            catppuccin.homeModules.catppuccin

            nix-flatpak.homeManagerModules.nix-flatpak
            nixvim.homeModules.nixvim
            claude-desktop.homeManagerModules.default
            nix-doom-emacs-unstraightened.homeModule

            nix-index-database.homeModules.default

            treesitter-kanata.homeManagerModules.nixvim
          ];

          extraModulesNixos = with inputs; [
            lanzaboote.nixosModules.lanzaboote
            chaotic.nixosModules.default

            home-manager.nixosModules.home-manager
          ];

          overlays = with inputs; [
            treesitter-kanata.overlays.default
            nur.overlays.default
          ];

          libx = import ./lib {
            inherit inputs;
            overlays = overlays ++ (import ./overlays);
          };
        in
        {
          overlays.default = overlays;

          nixosConfigurations = libx.builders.mkNixos {
            extraModules = [
              {
                # Embed Home Manager into Nixos
                home-manager = libx.builders.mkHome {
                  extraModules = extraModulesHome;
                  standalone = false;
                };
              }
            ]
            ++ extraModulesNixos;
          };

          homeConfigurations = libx.builders.mkHome { extraModules = extraModulesHome; };
        };
    };


  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    treefmt-nix.url = "github:numtide/treefmt-nix";

    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # ==================== system ====================

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v1.1.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    chaotic = {
      url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # ==================== home ====================

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # ======================= theme ==========================

    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    catppuccin.url = "github:catppuccin/nix";

    schemes = {
      url = "github:pbcdev210/schemes";
      flake = false;
    };

    # ======================= niri ==========================

    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # ======================= plasma ========================

    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    # ======================= nixvim ========================

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    treesitter-kanata = {
      url = "github:pbcdev210/treesitter-kanata";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    wezterm-types = {
      url = "github:/DrKJeff16/wezterm-types";
      flake = false;
    };

    # ======================= emacs =========================

    nix-doom-emacs-unstraightened = {
      url = "github:marienz/nix-doom-emacs-unstraightened";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # ======================= miscelaneous ===========================

    nix-flatpak.url = "github:gmodena/nix-flatpak/v0.7.0";
    claude-desktop.url = "github:Reginleif88/claude-cowork-nix";
    vscode-extensions.url = "github:nix-community/nix-vscode-extensions";

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
