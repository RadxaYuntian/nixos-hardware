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
    nixpkgs.overlays = [
      (import ./kernel/overlay.nix)
    ];

    boot = {
      kernelPackages = lib.mkOverride 900 pkgs.linuxPackages_6_6_89;
      extraModulePackages = with config.boot.kernelPackages; [
        cix_gpu_kernel
      ];
    };

    hardware.cix.enable = true;
  };
}
