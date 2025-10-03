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
      kernelPackages = lib.mkOverride 600 pkgs.linuxPackages_6_6;
      kernelParams = [
        "console=ttyAMA2,115200n8"
        "acpi=force"
      ];
      kernelPatches = [
        {
          name = "cix_p1_K6.6_2025Q3_dev";
          patch = pkgs.fetchpatch {
            url = "https://github.com/radxa/kernel/commit/fd1a9d06cef85f16a4dcb16061a9128437e235f4.patch";
            sha256 = "sha256-Kd6JxXaHfE/AUvQF7FRzjU1ELcz2baGocL1EbY68g8k=";
          };
        }
      ];
    };

    hardware.cix.enable = true;
  };
}
