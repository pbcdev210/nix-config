_:
[
  (final: prev: {
    myPkgs = {
      volume-control = final.callPackage ./volume-control { };
      brightness-control = final.callPackage ./brightness-control { };
      vivaldi-sync = final.callPackage ./vivaldi-sync { };
      audio-manager = final.callPackage ./audio-manager { };
      vaultwarden-sync = final.callPackage ./vaultwarden-sync { };
    };
  })
]
