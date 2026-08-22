{ inputs, pkgs, ... }@args:
let
  settings-profile = {
    "extensions.autoDisableScopes" = 0;
    "browser.ctrlTab.sortByRecentlyUsed" = true;

    "browser.tabs.allow_transparent_browser" = true;
    "zen.widget.linux.transparency" = true;
  };

  mods = [

  ];

  extensions = import ./extensions.nix args;
  keyboardShortcuts = import ./shortcuts.nix;
  policies = { };

  search = {
    force = true;
    default = "google";

    engines = {
      google = {
        name = "google";
        urls = [{ template = "https://www.google.com/search?q={searchTerms}"; }];
        icon = "https://www.google.com/favicon.ico";
        definedAliases = [ ":g" ];
      };

      github = {
        name = "github";
        urls = [{ template = "https://github.com/search?q={searchTerms}&type=repositories"; }];
        icon = "https://github.com/favicon.ico";
        definedAliases = [ ":gh" ];
      };

      nixpkgs = {
        name = "nixpkgs";
        urls = [{ template = "https://search.nixos.org/packages?channel=unstable&query={searchTerms}"; }];
        icon = "https://nixos.org/favicon.ico";
        definedAliases = [ ":pkgs" ];
      };

      nixos = {
        name = "nixos";
        urls = [{ template = "https://search.nixos.org/options?channel=unstable&query={searchTerms}&type=options"; }];
        icon = "https://nixos.org/favicon.ico";
        definedAliases = [ ":nos" ];
      };

      home-manager = {
        name = "home-manager";
        urls = [{ template = "https://home-manager-options.extranix.com/?query={searchTerms}&release=master"; }];
        icon = "https://nixos.org/favicon.ico";
        definedAliases = [ ":nos" ];
      };
    };
  };

  mkProfile = { name, id, extraConfig ? { } }: {
    inherit id name;

    settings = settings-profile;
    inherit keyboardShortcuts;
    keyboardShortcutsVersion = 20;
    inherit extensions mods search;
  } // extraConfig;
in
{
  programs.zen-browser = {
    enable = true;
    package = inputs.zen-browser-package.packages.${pkgs.stdenv.hostPlatform.system}.default;

    inherit policies;

    profiles = {
      work = mkProfile {
        name = "work";
        id = 0;
      };

      entertainment = mkProfile {
        name = "entertainment";
        id = 1;
      };

      society = mkProfile {
        name = "society";
        id = 2;
      };
    };
  };

  programs.niri.settings.window-rules = [{
    matches = [{ title = "Zen Browser$"; }];
    # background-effect = {
    #   blur = true;
    # };
    #
    # geometry-corner-radius = 12.0;
    clip-to-geometry = true;
  }];

  imports = [
    inputs.zen-browser.homeModules.beta
  ];
}
