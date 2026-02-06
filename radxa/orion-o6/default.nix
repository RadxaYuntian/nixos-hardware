{
  lib,
  pkgs,
  config,
  ...
}:
{
  imports = [
    ../.
  ];

  config = {
    boot.extraModulePackages = with config.boot.kernelPackages; [
      r8125
    ];

    hardware = {
      radxa.enable = true;
      cix = {
        sky1.enable = true;
      };
    };
  };
}
