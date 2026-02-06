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
        rk3328.enable = true;
        platformFirmware = lib.mkDefault pkgs.ubootRockPiE;
      };
    };
  };
}
