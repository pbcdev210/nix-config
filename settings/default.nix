rec {
  timeZone = "Asia/Ho_Chi_Minh";
  locale = "en_US.UTF-8";

  identity = import ./identity.nix;
  tools = import ./tools.nix;
  network = import ./network.nix;

  dirs = {
    home = "/home/${identity.username}";
    nixConfig = "/workspaces/nix-config";
  };

  glyphs = import ./glyphs.nix;
  ignores = import ./ignores.nix;

  hashedPassword = "$6$D0ewzu8Rhwdgv0k8$6SPkDIIRUKlRmC8.Sk89TUCdJYs35bG1aUN641wZWcsP/ul25wICjEq8sz57cIs1qGmoV4OdRcKlrmDiSPdqG.";
}
