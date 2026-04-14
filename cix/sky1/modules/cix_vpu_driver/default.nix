{
  stdenv,
  lib,
  fetchFromGitHub,
  kernel,
  kernelModuleMakeFlags,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cix_vpu_driver";
  version = "1.0.1-1";

  src = fetchFromGitHub {
    owner = "cixtech";
    repo = "cix_opensource__vpu_driver";
    rev = "8010c94da3534398555bb53f48332981e1469149";
    hash = "sha256-RRZPRHJBzwqw6vDL4TrPEoTcnQhFkOoh4JsDo6ky3e4=";
  };

  nativeBuildInputs = kernel.moduleBuildDependencies;

  makeFlags = kernelModuleMakeFlags ++ [
    "-C"
    "driver"
    "KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "M=$(PWD)/driver"
  ];

  enableParallelBuilding = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/firmware/
    cp firmware-binaries/* $out/lib/firmware/

    BUILD_OUTPUT=(
      amvx.ko
    )
    for i in "''${BUILD_OUTPUT[@]}"; do
      install -D driver/$i $out/lib/modules/${kernel.modDirVersion}/extra/$i
    done

    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/cixtech/cix_opensource__vpu_driver/tree/cix_mainline_dev";
    description = "CIX VPU driver";
    license = [
      lib.licenses.gpl2Plus
      lib.licenses.asl20
    ];
    platforms = lib.platforms.linux;
  };
})
