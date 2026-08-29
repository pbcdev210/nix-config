{ argv, ... }:
[
  (final: prev: {
    myPkgs = {
      volume-control = final.callPackage ./volume-control argv;
      brightness-control = final.callPackage ./brightness-control argv;
      vivaldi-backup = final.callPackage ./vivaldi-backup argv;
      audio-manager = final.callPackage ./audio-manager argv;
    };
  })
]
