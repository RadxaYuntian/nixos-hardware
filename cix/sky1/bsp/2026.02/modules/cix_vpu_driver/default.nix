{
  stdenv,
  lib,
  fetchFromGitLab,
  kernel,
  kernelModuleMakeFlags,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cix_vpu_driver";
  version = "2026.02";

  src = fetchFromGitLab {
    owner = "cix-linux";
    repo = "cix_opensource/vpu_driver";
    rev = "d93281c0b899af0b9632da1b1b27ac565a06a133";
    hash = "sha256-3bG0q66Lio6YLKZTlZamiBXGld9i6rkcYkRERScxgcI=";
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

    BUILD_OUTPUT=(
      amvx.ko
    )
    for i in "''${BUILD_OUTPUT[@]}"; do
      install -D driver/$i $out/lib/modules/${kernel.modDirVersion}/extra/$i
    done

    runHook postInstall
  '';

  meta = {
    homepage = "https://gitlab.com/cix-linux/cix_opensource/vpu_driver";
    description = "CIX VPU driver";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
})
