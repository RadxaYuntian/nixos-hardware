{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.hardware.cix.sky1;
in
{
  options.hardware.cix.sky1 = {
    enable = lib.mkEnableOption "CIX Sky1 support";
  };

  config = lib.mkIf cfg.enable {
    imports = [
      ./bsp/2025.09
    ];

    hardware.cix.enable = true;
  };
}
