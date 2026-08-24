{ extraArgv }:
[
  (final: prev:
    {
      myPkgs = {
        volume-control = final.callPackage ./volume-control extraArgv;
        brightness-control = final.callPackage ./brightness-control extraArgv;
      };
    })
]
