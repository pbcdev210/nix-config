{ extraArgv, extraModules, mkHomeModules }:
let
  modules = [
    setOptions

    ({ osConfig, ... }: {
      imports = (mkHomeModules { inherit (osConfig) profile desktop; });
    })
  ] ++ extraModules;

  setOptions = { osConfig, ... }: {
    config.standalone = false;
    config.profile = osConfig.profile;
    config.desktop = osConfig.desktop;
    config.name = "";
  };
in
{
  useGlobalPkgs = true;
  useUserPackages = true;
  backupFileExtension = "hm-backup";

  extraSpecialArgs = extraArgv;

  users.${extraArgv.settings.identity.username} = {
    imports = modules;
  };
}
