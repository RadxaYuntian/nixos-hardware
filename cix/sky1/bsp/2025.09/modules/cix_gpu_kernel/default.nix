{
  stdenv,
  lib,
  fetchFromGitLab,
  kernel,
  kernelModuleMakeFlags,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cix_gpu_kernel";
  version = "2025.09";

  src = fetchFromGitLab {
    owner = "cix-linux";
    repo = "cix_opensource/gpu_kernel";
    rev = "b8eee14f46f2aba8cdcf524a406a29ec75a0d8db";
    hash = "sha256-8QN5y3Vy/WF7cAWDNCDwe5obS2IzdI3FmXgRWAvWeZA=";
  };

  nativeBuildInputs = kernel.moduleBuildDependencies;

  makeFlags = kernelModuleMakeFlags ++ [
    "KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
  ];
  
  enableParallelBuilding = true;

  buildFlags = [
    "all"
  ];

  installPhase = ''
    runHook preInstall

    BUILD_OUTPUT=(
      base/arm/memory_group_manager/memory_group_manager.ko
      base/arm/protected_memory_allocator/protected_memory_allocator.ko
      gpu/arm/midgard/mali_kbase.ko
    )
    for i in "''${BUILD_OUTPUT[@]}"; do
      install -D drivers/$i $out/lib/modules/${kernel.modDirVersion}/$i
    done

    runHook postInstall
  '';

  meta = {
    homepage = "https://gitlab.com/cix-linux/cix_opensource/gpu_kernel";
    description = "CIX GPU driver";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
})
