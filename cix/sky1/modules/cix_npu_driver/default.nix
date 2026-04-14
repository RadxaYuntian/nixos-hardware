{
  stdenv,
  lib,
  fetchFromGitHub,
  kernel,
  kernelModuleMakeFlags,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cix_npu_driver";
  version = "6.1.1-2";

  src = fetchFromGitHub {
    owner = "cixtech";
    repo = "cix_opensource__npu_driver";
    rev = "193d3650645b1d3de9794aa024675c755d864d57";
    hash = "sha256-eq95TOZwG7lisyq5koSaoRK4QB+QVQcgDJj+3Ekgf2s=";
  };

  nativeBuildInputs = kernel.moduleBuildDependencies;

  makeFlags = kernelModuleMakeFlags ++ [
    "-C"
    "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "M=$(PWD)/driver"
    "COMPASS_DRV_BTENVAR_KPATH=$(KDIR)"
    "BUILD_AIPU_VERSION_KMD=BUILD_ZHOUYI_V3"
    "COMPASS_DRV_BTENVAR_KMD_VERSION=5.11.0"
    "BUILD_TARGET_PLATFORM_KMD=BUILD_PLATFORM_SKY1"
    "BUILD_NPU_DEVFREQ=y"
  ];

  enableParallelBuilding = true;

  buildFlags = [
    "modules"
  ];

  preBuild = ''
    substituteInPlace driver/Makefile --replace-fail '$(PWD)' $PWD/driver
  '';

  installPhase = ''
    runHook preInstall

    BUILD_OUTPUT=(
      aipu.ko
    )
    for i in "''${BUILD_OUTPUT[@]}"; do
      install -D driver/$i $out/lib/modules/${kernel.modDirVersion}/extra/$i
    done

    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/cixtech/cix_opensource__npu_driver/tree/cix_mainline_dev";
    description = "CIX NPU driver";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
})
