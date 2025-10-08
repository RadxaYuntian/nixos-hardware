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
    boot.kernelModules = [
      "r8125"
    ];

    hardware = {
      radxa.enable = true;
      cix = {
        sky1.enable = true;
      };
    };
  };
}
