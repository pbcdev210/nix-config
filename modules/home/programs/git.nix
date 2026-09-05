{
  pkgs,
  settings,
  dirs,
  ...
}:
{
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = settings.identity.name;
        email = settings.identity.email.main;
      };
      init = {
        defaultBranch = "main";
      };

      # github
      "credential \"https://github.com\"".helper = [
        ""
        "${pkgs.github-cli} auth git-credential"
      ];
      "credential \"https://gist.github.com\"".helper = [
        ""
        "${pkgs.github-cli}/bin/gh auth git-credential"
      ];

      # sign
      gpg.format = "ssh";
      commit.gpgSign = true;

      user.signingKey = "${settings.dirs.home}/.ssh/id_ed25519.pub";
    };
    inherit (settings) ignores;
  };

  programs.delta.enableGitIntegration = true;
}
