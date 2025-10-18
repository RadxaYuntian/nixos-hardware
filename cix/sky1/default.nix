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

    bspRelease = lib.mkOption {
      type = enum [
        "2025.04"
        "2025.09"
      ];
      default = "2025.09";
      description = ''
        Select the BSP release that will be used on the system.
      '';
    };
  };

  imports = [
    ./bsp/2025.04
    ./bsp/2025.09
  ];

  config = lib.mkIf cfg.enable {
    hardware.cix.enable = true;
  };
}
