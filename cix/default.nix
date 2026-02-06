{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.hardware.cix;
in
{
  imports = [
    ./sky1
  ];

  options.hardware.cix = {
    enable = lib.mkEnableOption "CIX SoC support";
  };

  config = lib.mkIf cfg.enable {
    boot = {
      kernelParams = [
        "acpi=force"
        "kasan=off"
      ];
    };
  };
}
