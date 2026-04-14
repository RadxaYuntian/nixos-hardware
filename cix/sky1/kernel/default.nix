{
  lib,
  linux,
  fetchFromGitHub,
  branch,
  ...
}@args:

let
  cix-linux-main = fetchFromGitHub {
    owner = "cixtech";
    repo = "cix-linux-main";
    rev = "0aebbccfd5694e7f0ba6aaae8be7e74b86bc3fa6";
    sha256 = "sha256-C8Q38LAzGEOimkmoXAezh2cQkScV0Xqe0/WaVDAzPQA=";
  };

  cix_patches = (lib.filesystem.listFilesRecursive "${cix-linux-main}/patches-${branch}");
  kPatches = lib.map (x: {
    name = "${x}";
    patch = x;
  }) cix_patches;

in

linux.overrideAttrs (
  finalAttrs: previousAttrs: {
    defconfig = "defconfig cix.config";

    kernelPatches = [
      kPatches
    ];

    prePatch = ''
      cp ${cix-linux-main}/config/config-${branch}.defconfig arch/arm64/configs/cix.config
    ''; # postPatch is already occupied
  }
)
