{ inputs, pkgs, ... }@args:
let
  settings-profile = { };

  extensions = import ./extensions.nix args;
  keyboardShortcuts = import ./shortcuts.nix;
  policies = import ./policies.nix args;

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

      nuget = {
        name = "nuget";
        urls = [{ template = "https://www.nuget.org/packages?q={searchTerms}"; }];
        icon = "https://nuget.org/public/favicon.ico";
        definedAliases = [ ":ng" ];
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
        definedAliases = [ ":hm" ];
      };

      youtube = {
        name = "youtube";
        urls = [{ template = "https://www.youtube.com/results?search_query={searchTerms}"; }];
        icon = "https://youtube.com/favicon.ico";
        definedAliases = [ ":yt" ];
      };
    };
  };

  mkProfile = { name, id, extraConfig ? { } }: {
    inherit id name;

    settings = settings-profile;
    inherit extensions search;
  } // extraConfig;
in
{
  programs.floorp = {
    enable = true;

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
}
