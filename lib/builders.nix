{ inputs, overlays }:
let
  # ==================== Config ====================

  hosts = [ "dp7530" ];
  hostDefault = "dp7530";

  hostPlatforms = [ "x86_64-linux" ];
  hostPlatformPriority = "x86_64-linux";

  profiles = [ "desktop" ];
  profileDefault = "desktop";

  dir = rec {
    root = inputs.self;

    nixos = "${root}/system";

    home = "${root}/home";
    hosts = "${nixos}/hosts";

    nixosProfiles = "${nixos}/profiles";
    homeProfiles = "${home}/profiles";
  };

  # ==================== Global ====================

  inherit (inputs) nixpkgs;

  settings = import "${dir.root}/settings";

  libx = import "${dir.root}/lib";

  # ==================== Nixos ====================
  nixos = {
    mkModules = { host, profile, extraModules }: [
      "${dir.hosts}/${host}"
      "${dir.nixosProfiles}/${profile}"
      "${dir.nixos}/base.nix"
      "${dir.nixos}/virtualisation.nix"
    ] ++ extraModules;

    specialArgs = {
      inherit inputs settings libx;
      # libxNixos = import "${dir.nixos}/lib";
      systemDir = "${dir.nixos}";
      modulesDir = "${dir.nixos}/modules";
      programsDir = "${dir.nixos}/programs";
      servicesDir = "${dir.nixos}/services";
      desktopsDir = "${dir.nixos}/desktops";
    };

    mkBase = { host, profile, extraModules, name ? "${host}-${profile}" }: {
      ${name} = nixpkgs.lib.nixosSystem {
        inherit (nixos) specialArgs;
        modules = (nixos.mkModules { inherit host profile extraModules; }) ++ [
          ({ lib, ... }: {
            options._profile = lib.mkOption {
              type = lib.types.enum profiles;
              description = "This helps Home Manager identify the target profile";
            };
            config = {
              _profile = profile;

              nixpkgs = {
                inherit overlays;
                config.allowUnfree = true;
              };
            };
          })
        ];
      };
    };

    default = nixos.mkBase {
      host = hostDefault;
      profile = profileDefault;
      extraModules = [ ];
      name = "nixos";
    };

    mkNixos = { extraModules ? [ ], }:
      let
        configCombination = nixpkgs.lib.cartesianProduct {
          host = hosts;
          profile = profiles;
        };

        configs = (map ({ host, profile }: nixos.mkBase { inherit host profile extraModules; }) configCombination) ++ [ nixos.default ];
      in
      nixpkgs.lib.mergeAttrsList configs;
  };

  # ==================== Home-Manager ====================

  home = {
    mkModules = { profile, extraModules }: [
      "${dir.homeProfiles}/${profile}"
      "${dir.home}/base.nix"
    ] ++ extraModules;

    specialArgs = {
      inherit inputs settings libx;
      # libHome = import "${dir.home}/lib";
      homeDir = dir.home;
      modulesDir = "${dir.home}/modules";
      programsDir = "${dir.home}/programs";
      servicesDir = "${dir.home}/services";
      desktopsDir = "${dir.home}/desktops";
      developDir = "${dir.home}/develop";
    };

    mkBase-standalone = { profile, hostPlatform, extraModules, raw ? false }:
      let
        common = {
          extraSpecialArgs = home.specialArgs;

          modules = home.mkModules { inherit profile extraModules; };

          pkgs = import nixpkgs {
            inherit overlays;
            localSystem = { system = hostPlatform; };
            config.allowUnfree = true;
          };
        };
      in
      if raw then
        inputs.home-manager.lib.homeManagerConfiguration common
      else if (hostPlatform == hostPlatformPriority) then
        { ${profile} = inputs.home-manager.lib.homeManagerConfiguration common; }
      else
        { "${profile}-${hostPlatform}" = inputs.home-manager.lib.homeManagerConfiguration common; };

    default = home.mkBase-standalone {
      default = home.mkBase-standalone {
        profile = profileDefault;
        hostPlatform = hostPlatformPriority;
        raw = true;
      };
    };

    mkHome = { extraModules ? [ ], standalone ? true }:
      let
        configCombination = nixpkgs.lib.cartesianProduct {
          hostPlatform = hostPlatforms;
          profile = profiles;
        };

        configs = (map ({ hostPlatform, profile }: home.mkBase-standalone { inherit hostPlatform profile extraModules; }) configCombination);
      in
      if standalone then
        (nixpkgs.lib.mergeAttrsList (configs ++ [{ default = home.default; }]))
      else
        {
          extraSpecialArgs = home.specialArgs;

          useGlobalPkgs = true;
          useUserPackages = true;
          backupFileExtension = "hm-backup";

          users.${settings.identity.username} = { osConfig, ... }: {
            imports = home.mkModules {
              inherit extraModules;
              profile = osConfig._profile;
            };
          };
        };
  };
in
{
  inherit (nixos) mkNixos;
  inherit (home) mkHome;
}
