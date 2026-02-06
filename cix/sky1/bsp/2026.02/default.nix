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
  config = lib.mkIf (cfg.enable && cfg.bspRelease == "2026.02") {
    nixpkgs.overlays = [
      (import ./overlay.nix)
      (final: prev: {
        linuxPackages_cix = final.linuxPackages_6_6_89;
        cix_gpu_firmware = final.cix_gpu_firmware_2026_02;
        cix_vpu_firmware = final.cix_vpu_firmware_2026_02;
      })
    ];

    boot = {
      kernelPackages = lib.mkOverride 900 pkgs.linuxPackages_cix;
      extraModulePackages = with config.boot.kernelPackages; [
        cix_vpu_driver
      ];
      extraModprobeConfig = ''
        options linlon-dp enable_render=0 # conflict with Panthor
      '';
    };

    hardware.firmware = with pkgs; [
      cix_gpu_firmware
      cix_vpu_firmware
    ];
  };
}
