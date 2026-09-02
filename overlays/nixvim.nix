{ inputs, ... }:
final: prev: {
  nixvim = inputs.self.nixvimConfiguration.${final.stdenv.system}.config.build.package;

  neovide = prev.symlinkJoin {
    name = "neovide-wrapped";
    paths = [ prev.neovide ];
    postBuild = ''
      rm $out/bin/neovide
      ln -s ${prev.writeShellScript "neovide-bg" ''
        setsid ${prev.neovide}/bin/neovide &
      ''} $out/bin/neovide
    '';
  };
}
