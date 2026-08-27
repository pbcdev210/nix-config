{ inputs, ... }:
{
  imports = with inputs; [
    nix-doom-emacs-unstraightened.homeModule
  ];
  programs.doom-emacs = {
    enable = true;
  };
}
