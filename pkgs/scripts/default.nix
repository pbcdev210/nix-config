{ extraArgv }:
final: prev:
{
  myScripts = {
    volume-control = final.callPackage ./volume-control extraArgv;
    brightness-control = final.callPackage ./brightness-control extraArgv;
  };
}
