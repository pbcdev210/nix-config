{ config, ... }:
{
  # home.packages = with pkgs; [ neovide ];

  programs.neovide = {
    enable = true;
    settings = {
      font.size = config.stylix.fonts.sizes.terminal;
      font.normal = config.stylix.fonts.monospace.name;
      wayland-app-id = "neovim";
    };
  };

  programs.nixvim.globals = {
    # https://github.com/neovide/neovide/issues/2275
    neovide_opacity = 1;

    neovide_normal_opacity = 0.4;
    neovide_floating_shadow = true;
    neovide_cursor_vfx_mode = "pixiedust";
    neovide_fullscreen = false;

    neovide_padding_top = 10;
    neovide_padding_bottom = 5;
    neovide_padding_left = 10;
    neovide_padding_right = 10;

    neovide_hide_mouse_when_typing = true;

    neovide_confirm_quit = true;
  };
}
