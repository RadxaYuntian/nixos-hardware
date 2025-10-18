{
  lib,
  pkgs,
  config,
  ...
}:
{
  nixpkgs.overlays = [
    (import ./overlay.nix)
  ];

  boot = {
    kernelPackages = lib.mkOverride 900 pkgs.linuxPackages_cix;
  };
}