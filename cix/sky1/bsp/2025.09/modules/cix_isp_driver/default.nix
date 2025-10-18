{
  stdenv,
  lib,
  fetchFromGitLab,
  kernel,
  kernelModuleMakeFlags,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cix_isp_driver";
  version = "2025.09";

  src = fetchFromGitLab {
    owner = "cix-linux";
    repo = "cix_opensource/isp_driver";
    rev = "3bf2fcc349eaec64535203a10b56ddac9ef5f19f";
    hash = "sha256-JDRMr+BOXLkwNQXeZIzWlR/diV8L1B9A5KPgZioWJII=";
  };

  nativeBuildInputs = kernel.moduleBuildDependencies;

  makeFlags = kernelModuleMakeFlags;

  enableParallelBuilding = true;

  buildFlags = [
    "build"
  ];

  preBuild = ''
    substituteInPlace Makefile --replace-fail "\''${PATH_ROOT}/linux" '$(KBUILD_OUTPUT)'
    substituteInPlace Makefile --replace-fail '$(PWD)' $PWD
  '';

  installPhase = ''
    runHook preInstall

    BUILD_OUTPUT=(
      armcb_isp_v4l2.ko
    )
    for i in "''${BUILD_OUTPUT[@]}"; do
      install -D $i $out/lib/modules/${kernel.modDirVersion}/extra/$i
    done

    runHook postInstall
  '';

  meta = {
    homepage = "https://gitlab.com/cix-linux/cix_opensource/isp_driver";
    description = "CIX ISP driver";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
})
