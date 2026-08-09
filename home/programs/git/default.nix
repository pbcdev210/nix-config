{ pkgs, settings, ... }: {
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

      "credential \"https://github.com\"" = {
        helper = [
          ""
          "${pkgs.github-cli}/bin/gh auth git-credential"
        ];
      };

      "credential \"https://gist.github.com\"" = {
        helper = [
          ""
          "${pkgs.github-cli}/bin/gh auth git-credential"
        ];
      };
    };
    inherit (settings) ignores;
  };

  programs.delta.enableGitIntegration = true;
}
