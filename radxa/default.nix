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
  imports = [
    ../cix
    ../rockchip
  ];

  options.hardware.radxa = {
    enable = lib.mkEnableOption "Radxa system support";
    cachix.enable = lib.mkEnableOption ''
      Radxa Cachix binary cache.

      This is a runtime option. If you are cross building system images, you
      need to run `cachix use radxa` on your build machine.
    '';
  };

  config = lib.mkIf cfg.enable {
    boot = {
      kernelPackages = lib.mkOverride 990 pkgs.linuxPackages_latest;
      loader.systemd-boot.enable = lib.mkDefault true;
    };

    nix.settings = lib.mkIf cfg.cachix.enable {
      substituters = [
        "https://radxa.cachix.org"
      ];
      trusted-public-keys = [
        "radxa.cachix.org-1:Jc5T8fpq3URBLeKKHER2PxcuAd74iPMiW6TOb1M1yPc="
      ];
    };
  };
}
