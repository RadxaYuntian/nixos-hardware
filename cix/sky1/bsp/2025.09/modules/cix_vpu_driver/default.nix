{
  stdenv,
  lib,
  fetchFromGitLab,
  kernel,
  kernelModuleMakeFlags,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cix_vpu_driver";
  version = "2025.09";

  src = fetchFromGitLab {
    owner = "cix-linux";
    repo = "cix_opensource/vpu_driver";
    rev = "41682d980377ea5c94280cd936238258a2116589";
    hash = "sha256-UAl4acdYwMHi4SM6VlRsZqTqACeaaOhr36sMTM52Nfw=";
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
