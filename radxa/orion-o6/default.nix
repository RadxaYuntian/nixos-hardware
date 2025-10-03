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
      cix = {
        sky1.enable = true;
      };
    };
  };
}
