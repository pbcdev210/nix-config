{ argv, ... }:
[
  (final: prev: {
    myPkgs = {
      volume-control = final.callPackage ./volume-control argv;
      brightness-control = final.callPackage ./brightness-control argv;
      vivaldi-sync = final.callPackage ./vivaldi-sync argv;
      audio-manager = final.callPackage ./audio-manager argv;
      vaultwarden-sync = final.callPackage ./vaultwarden-sync argv;
    };
  })
]
