final: prev: {
  dotnet-sdk_10 = prev.dotnetCorePackages.sdk_10_0-bin;
  dotnet-runtime_10 = prev.dotnetCorePackages.runtime_10_0-bin;
  roslyn-ls = prev.roslyn-ls.override {
    dotnetCorePackages = prev.dotnetCorePackages // {
      sdk_10_0 = prev.dotnetCorePackages.sdk_10_0-bin;
    };
  };
}
