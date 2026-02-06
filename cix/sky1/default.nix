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
      type = lib.types.enum [
        "2026.02"
        "none"
      ];
      default = "2026.02";
      description = ''
        Select the BSP release that will be used on the system.

        A special `none` option is available to disable system configuration
        associated with a specific BSP release. Only packages are added via the
        overlay to allow manual configuration.
      '';
    };
  };

  imports = [
    ./bsp/2026.02
    ./bsp/none
  ];

  config = lib.mkIf cfg.enable {
    hardware.cix.enable = true;
  };
}
