{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  pkg-config,
  cix_libva,
  libdrm,
}:
let
  vpu_driver = fetchFromGitHub {
    owner = "cixtech";
    repo = "cix_opensource__vpu_driver";
    rev = "8010c94da3534398555bb53f48332981e1469149";
    hash = "sha256-RRZPRHJBzwqw6vDL4TrPEoTcnQhFkOoh4JsDo6ky3e4=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "cix_vaapi_driver";
  version = "2026.Q1";

  src = fetchFromGitHub {
    owner = "cixtech";
    repo = "cix_vaapi";
    rev = "22c4e2ef573092eb3d73ff9a26e4f5c6f8927730";
    hash = "sha256-b7G6hQt5zvrj/WA0cVHwH3nR2mk02wBgnb3rVwGi4n8=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    cix_libva
    libdrm
  ];

  prePatch = ''
    cp ${vpu_driver}/driver/linux/mvx-v4l2-controls.h devices/v4l2/
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/dri
    cp libcix_va_drv_video.so $out/lib/dri/

    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/cixtech/cix_vaapi";
    description = "CIX VAAPI driver";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
  };
})
