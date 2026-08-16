{ inputs, ... }:
(final: prev:
{
  waycal = prev.callPackage ./drv.nix { sources = { inherit (inputs) waycal; }; };
})
