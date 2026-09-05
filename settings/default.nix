rec {
  timeZone = "Asia/Ho_Chi_Minh";
  locale = "en_US.UTF-8";

  identity = {
    name = "PBCDev";
    username = "pbcdev";

    email = {
      main = "baochaupham4096@gmail.com";
      sub = "baochaupham3205@gmail.com";
    };
  };

  tools = import ./tools.nix;

  dirs = rec {
    home = "/home/${identity.username}";
    nixConfig = "/workspaces/nix-config";
    nixConfigBot = "/workspaces/nix-config-bot";
    data = "${nixConfigBot}/data";
  };

  glyphs = import ./glyphs.nix;
  ignores = import ./ignores.nix;

  age = {
    publicKey = "age1mwp4mujj0cq40sc4yn33el4lxaap86wlrxzhyf73h7ecsm0gx5yqas8pf0";
    privateKeyPath = "${dirs.home}/.config/sops/age/keys.txt";
  };

  ssh = {
    pub = builtins.readFile "${dirs.data}/ssh.pub";
    privateKeyPath = "${dirs.home}/.ssh/id_ed25519";
  };

  repo = {
    github = "https://github.com/pbcdev210/nix-config";
  };
}
