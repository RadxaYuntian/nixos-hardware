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

  imports = lib.optional cfg.enable ./bsp/2025.09;

  config = lib.mkIf cfg.enable {

    hardware.cix.enable = true;
  };
}
