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
    hardware.cix.enable = true;

    nixpkgs.overlays = [
      (import ./overlay.nix)
    ];

    boot = {
      kernelPackages = lib.mkOverride 900 pkgs.linuxPackages_cix;
      extraModulePackages = with config.boot.kernelPackages; [
        cix_vpu_driver
      ];
      extraModprobeConfig = ''
        # options linlon-dp enable_render=0 # conflict with Panthor
      '';
    };

    hardware = {
      firmware = with config.boot.kernelPackages; [
        cix_vpu_driver
      ];
      graphics.extraPackages = [ pkgs.cix_vaapi_driver ];
    };
  };
}
