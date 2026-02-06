{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.hardware.cix.sky1;
in
{
  config = lib.mkIf (cfg.enable && cfg.bspRelease == "none") {
    nixpkgs.overlays = [
      (import ../2026.02/overlay.nix)
    ];
  };
}
