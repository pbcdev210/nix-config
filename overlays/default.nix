{ inputs }:
[
  (import ./dotnet-sdk10-bin)
  (import ./waycal { inherit inputs; })
  (import ./nushell-plugins { inherit inputs; })
]
