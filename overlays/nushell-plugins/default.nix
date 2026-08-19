{ inputs, ... }:
final: prev: {
  nushellPlugins = prev.nushellPlugins // {
    highlight = prev.rustPlatform.buildRustPackage {
      pname = "nu_plugin_highlight";
      version = inputs.nushell-highlight.shortRev or "dirty";
      src = inputs.nushell-highlight;
      cargoHash = "sha256-bJBiCouZ4tY/Sbnrxk04MOG2sQCR876PtumjkpsK5cU=";
    };
  };
}
