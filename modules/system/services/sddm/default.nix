{ pkgs, ... }:
let
  sddm-astronaut = (pkgs.sddm-astronaut.override {
    embeddedTheme = "astronaut";
    themeConfig = {
      HeaderTextColor = "#d5c4a1";
      # Background = "Backgrounds/your-custom-background.png";
    };
  }).overrideAttrs (oldAttrs: {
    installPhase = oldAttrs.installPhase; # ''
    # chmod u+w $out/share/sddm/themes/sddm-astronaut-theme/Backgrounds/
    #cp ${./relative/path/to/your-custom-background.png} \
    #  $out/share/sddm/themes/sddm-astronaut-theme/Backgrounds/your-custom-background.png
    # '' ;
  });
in
{
  environment.systemPackages = [ sddm-astronaut pkgs.kdePackages.qtmultimedia ];

  services.displayManager.sddm = {
    enable = true;

    theme = "sddm-astronaut-theme";
  };
  services.displayManager.defaultSession = "niri";
}

