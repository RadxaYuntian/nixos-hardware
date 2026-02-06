final: _prev: {
  linuxKernel = _prev.linuxKernel // {
    kernels = _prev.linuxKernel.kernels // {
      linux_6_6_89 = final.callPackage ./kernel {};
    };
    vanillaPackages = _prev.linuxKernel.vanillaPackages // {
      linux_6_6_89 = final.lib.recurseIntoAttrs ((final.linuxKernel.packagesFor final.linuxKernel.kernels.linux_6_6_89).extend (
        _: _: {
          cix_vpu_driver = final.linuxKernel.packages.linux_6_6_89.callPackage ./modules/cix_vpu_driver { };
        }
      ));
    };
  };
  linuxPackages_6_6_89 = final.linuxKernel.packages.linux_6_6_89;
  linux_6_6_89 = final.linuxKernel.kernels.linux_6_6_89;

  cix_gpu_firmware_2026_02 = final.callPackage ./firmwares/cix_gpu_firmware {};
  cix_vpu_firmware_2026_02 = final.callPackage ./firmwares/cix_vpu_firmware {};
}
