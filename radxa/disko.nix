{
  lib,
  pkgs,
  config,
  ...
}:
{
  imports = [
    ../cix/disko.nix
    ../rockchip/disko.nix
  ];
}
