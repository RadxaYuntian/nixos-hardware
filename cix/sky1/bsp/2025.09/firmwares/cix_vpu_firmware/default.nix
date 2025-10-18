{
  stdenvNoCC,
  lib,
  fetchFromGitLab,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "cix_vpu_firmware";
  version = "2025.09";

  src = fetchFromGitLab {
    owner = "cix-linux";
    repo = "cix_proprietary/cix_proprietary";
    rev = "06fe36730b79ad9969f537571b0cf6395ed82c5a";
    hash = "sha256-AniOa53zX/qpm8kqtlxGw9bckr7XtMlpEJAHxxySWHA=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/firmware/
    cp cix_proprietary-debs/cix-vpu-umd/usr/lib/firmware/* $out/lib/firmware/

    runHook postInstall
  '';

  meta = {
    description = "Firmware for CIX VPU driver";
    homepage = "https://gitlab.com/cix-linux/cix_proprietary/cix_proprietary";
    license = lib.licenses.unfreeRedistributableFirmware;
    platforms = lib.platforms.linux;
  };
})
