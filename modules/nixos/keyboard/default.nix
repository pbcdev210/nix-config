{
  services.kanata = {
    enable = true;
    keyboards = {
      default = {
        devices = [ ];
        config = ''
          (defsrc
            caps
          )

          (deflayer default
            esc
          )
        '';
      };
    };
  };
}
