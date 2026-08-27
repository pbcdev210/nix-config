{ inputs }:
[
  (import ./dotnet)
  (import ./waycal { inherit inputs; })
  (import ./nushell-plugins { inherit inputs; })
]
