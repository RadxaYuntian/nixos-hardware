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
    hardware = {
      radxa.enable = true;
      rockchip = {
        rk3588.enable = true;
        platformFirmware = lib.mkDefault pkgs.ubootRock5ModelB;
      };
    };
  };
}
