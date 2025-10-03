{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.hardware.radxa;
in
{
  options.hardware.radxa = {
    enable = lib.mkEnableOption "Radxa system support";
  };

  config = lib.mkIf cfg.enable {
    boot = {
      kernelPackages = lib.mkOverride 500 pkgs.linuxPackages_latest;
      loader.systemd-boot.enable = lib.mkDefault true;
    };
  };
}
