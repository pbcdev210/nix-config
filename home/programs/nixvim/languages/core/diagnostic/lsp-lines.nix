{
  programs.nixvim.plugins.lsp-lines = {
    enable = true;
  };
  programs.nixvim.diagnostic.settings = {
    virtual_text = false;
    virtual_lines = true;
  };
}
