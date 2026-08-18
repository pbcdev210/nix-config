{ inputs, ... }:
{
  imports = with inputs; [
    catppuccin.homeModules.catppuccin
  ];
  catppuccin = {
    enable = true;
    autoEnable = true;
    flavor = "mocha";
    accent = "blue";

    fcitx5.enable = false;
    kitty.enable = false;
    vscode.profiles.default.enable = false;
  };
}
