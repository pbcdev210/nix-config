{
  programs.nixvim.diagnostic = {
    settings = {
      update_in_insert = true;
      float = {
        border = "rounded";
        source = "always";
      };
      severity_sort = true;
    };
  };
  imports = [
    ./lsp-lines.nix
  ];
}
