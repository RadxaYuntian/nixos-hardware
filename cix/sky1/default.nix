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
    boot = {
      kernelPackages = lib.mkOverride 900 (pkgs.linuxPackagesFor (pkgs.callPackage ./kernel-6.6.10.nix {}));
      kernelParams = [
        "console=ttyAMA2,115200n8"
        "acpi=force"
      ];
    };

    hardware.cix.enable = true;
  };
}
