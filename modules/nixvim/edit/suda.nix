{ pkgs, ... }:
{
  programs.nixvim = {
    extraPlugins = [
      pkgs.vimPlugins.vim-suda
    ];

    globals = {
      suda_smart_edit = 1;
    };
  };
}
