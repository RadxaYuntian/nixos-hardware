{
  stdenv,
  lib,
  fetchFromGitLab,
  kernel,
  kernelModuleMakeFlags,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cix_npu_driver";
  version = "5.11.0";

  src = fetchFromGitLab {
    owner = "cix-linux";
    repo = "cix_opensource/npu_driver";
    rev = "a1b161f868f4019c4a1e5c843b0f5c93131e7726";
    hash = "sha256-e5GIXzA+0x095H54I/T2QAfHVHOWY2dwJhCpdYUJF2k=";
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
    homepage = "https://gitlab.com/cix-linux/cix_opensource/npu_driver";
    description = "CIX NPU driver";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
})
