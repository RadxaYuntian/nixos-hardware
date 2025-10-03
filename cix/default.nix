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
    diskoImageName = lib.mkOption {
      type = lib.types.str;
      default = "main.raw";
      description = ''
        The output image name of Disko.
        You need to match this value with the real image name. Setting it alone
        won't change the output image name, as it is controlled by Disko module.

        Can be used in diskoExtraPostVM.
      '';
    };
    platformFirmware = lib.mkPackageOption pkgs "platform firmware" {
      default = null;
    };
    diskoExtraPostVM = lib.mkOption {
      type = lib.types.str;
      description = ''
        The post VM hook for Disko's Image Builder.
        Can be used to install platform firmware like U-Boot.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    boot = {
      kernelParams = [
        "console=ttyAMA2,115200n8"
        "acpi=force"
      ];
    };
  };
}
