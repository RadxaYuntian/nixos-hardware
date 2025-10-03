{
  lib,
  pkgs,
  config,
  ...
}:
{
  imports = [
    ../.
    ../../cix
  ];

  config = {
    hardware = {
      radxa.enable = true;
      cix = {
        sky1.enable = true;
      };
    };
  };
}
