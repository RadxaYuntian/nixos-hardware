{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.hardware.rockchip;
in
{
  config = lib.mkIf cfg.enable {
    disko = {
      imageBuilder = {
        extraPostVM = cfg.diskoExtraPostVM;
      };
      memSize = lib.mkDefault 4096; # Default 1024 MB will throw "Cannot allocate memory" error
      devices.disk.main = {
        type = "disk";
        imageSize = lib.mkDefault "3G";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              type = "EF00";
              size = "1G";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0022" ];
              };
            };
            root = {
              size = "100%";
              content = {
                type = "filesystem";
                format = "btrfs";
                mountpoint = "/";
              };
            };
          };
        };
      };
    };
  };
}
