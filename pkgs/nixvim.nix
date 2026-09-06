{
  pkgs,
  builder,
  ...
}:
{
  ecode = builder.mkNvimPkg {
    profile = "ecode";
    inherit pkgs;
  };
}
