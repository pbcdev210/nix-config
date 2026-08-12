{
  programs.nixvim.plugins.blink-cmp = {
    enable = true;
    autoLoad = true;

    setupLspCapabilities = true;

    settings = {
      keymap = {
        preset = "none";

        "<A-Tab>" = [ "select_next" "fallback" ];
        "<A-q>" = [ "select_prev" "fallback" ];

        "<Down>" = [ "select_next" "fallback" ];
        "<Up>" = [ "select_prev" "fallback" ];

        "<C-space>" = [ "show" "show_documentation" "hide_documentation" ];
        "<Tab>" = [ "accept" "fallback" ];
      };

      appearance = {
        nerd_font_variant = "mono";
        use_nvim_cmp_as_default = false;
      };

      completion = {
        accept.auto_brackets.enabled = true;

        menu = {
          border = "rounded";
          max_height = 10;
          min_width = 15;
          draw = {
            columns = [
              [ "kind_icon" "label" "label_description" ]
              [ "kind" ]
            ];
            kind_icon = {
              ellipsis = false;

              text.__raw = ''
                function(ctx)
                  local icon = ctx.kind_icon
                  if ctx.item.source_name == "Path" then
                    local dev_icon, _ = require("nvim-web-devicons").get_icon(ctx.label)
                    if dev_icon then
                      icon = dev_icon
                    end
                  else
                    icon = require("lspkind").symbolic(ctx.kind, { mode = "symbol" })
                  end
                  return icon .. ctx.icon_gap
                end
              '';

              highlight.__raw = ''
                function(ctx)
                  local hl = ctx.kind_hl
                  if ctx.item.source_name == "Path" then
                    local dev_icon, dev_hl = require("nvim-web-devicons").get_icon(ctx.label)
                    if dev_icon then
                      hl = dev_hl
                    end
                  end
                  return hl
                end
              '';
            };
          };
        };
      };

      documentation = {
        auto_show = true;
        auto_show_delay_ms = 200;
        window.border = "rounded";
      };

      ghost_text.enabled = true;

      trigger.show_on_keyword = true;

      window.border = "rounded";

      fuzzy = {
        frecency.enabled = true;
        implementation = "prefer_rust_with_warning"; # "rust" | "lua" | "prefer_rust..."
        sorts = [ "score" "sort_text" ];
        use_proximity = true;
      };

      snippets = {
        preset = "luasnip";
      };
      sources = {
        default = [ "lsp" "path" "snippets" "buffer" ];

        providers = {
          lsp = {
            name = "LSP";
            module = "blink.cmp.sources.lsp";
            score_offset = 90;
          };
          path = {
            name = "Path";
            module = "blink.cmp.sources.path";
            score_offset = 3;
            opts.trailing_slash = false;
          };
          snippets = {
            name = "Snippets";
            module = "blink.cmp.sources.snippets";
            score_offset = 85;
          };
          buffer = {
            name = "Buffer";
            module = "blink.cmp.sources.buffer";
            score_offset = 0;
            min_keyword_length = 3;
          };
        };
      };
    };
  };
}

