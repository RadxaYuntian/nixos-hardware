{
  stdenvNoCC,
  lib,
  fetchFromGitLab,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "cix_gpu_firmware";
  version = "2026.02";

  src = fetchFromGitLab {
    owner = "cix-linux";
    repo = "cix_proprietary/cix_proprietary";
    rev = "e56e614aa57c2d35317ed0d6e2f010e596fc93c3";
    hash = "sha256-MyBfu8APSPwPqmVua8eUUW2O9XM8mUHCBqLSo+dRxqQ=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/firmware/
    cp cix_proprietary-debs/cix-gpu-umd/usr/lib/firmware/mali_csffw.bin $out/lib/firmware/

    runHook postInstall
  '';

  meta = {
    description = "Firmware for CIX GPU driver";
    homepage = "https://gitlab.com/cix-linux/cix_proprietary/cix_proprietary";
    license = lib.licenses.unfreeRedistributableFirmware;
    platforms = lib.platforms.linux;
  };
})
