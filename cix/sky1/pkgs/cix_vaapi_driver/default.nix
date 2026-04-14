{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  pkg-config,
  libva,
}:

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
    libva
  ];

  meta = {
    homepage = "https://github.com/cixtech/cix_vaapi";
    description = "CIX VAAPI driver";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
  };
})
