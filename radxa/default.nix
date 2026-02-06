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
    cachix.enable = lib.mkEnableOption ''
      Radxa Cachix binary cache.

      This is a runtime option. If you are cross building system images, you
      need to run `cachix use radxa` on your build machine.
    '';
  };

  config = lib.mkIf cfg.enable {
    boot = {
      # Currently enable bcachefs automatically set
      # kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;
      # TODO: Consider removing this line once, we get an LTS kernel that is newer than 6.12
      kernelPackages = lib.mkOverride 990 pkgs.linuxPackages_latest;
      supportedFilesystems = [ "bcachefs" ];
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
