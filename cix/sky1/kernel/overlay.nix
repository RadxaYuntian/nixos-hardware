final: _prev: {
  linuxKernel = _prev.linuxKernel // {
    kernels = _prev.linuxKernel.kernels // {
      linux_6_6_89 = final.callPackage ./linux-6.6.89.nix {};
    };
    vanillaPackages = _prev.linuxKernel.vanillaPackages // {
      linux_6_6_89 = final.recurseIntoAttrs ((final.linuxKernel.packagesFor final.linuxKernel.kernels.linux_6_6_89).extend (
        _: previous: {
          cix_gpu_kernel = final.linuxKernel.packages.linux_6_6_89.callPackage ./modules/cix_gpu_kernel { };
          cix_isp_driver = final.linuxKernel.packages.linux_6_6_89.callPackage ./modules/cix_isp_driver { };
          cix_npu_driver = final.linuxKernel.packages.linux_6_6_89.callPackage ./modules/cix_npu_driver { };
          cix_vpu_driver = final.linuxKernel.packages.linux_6_6_89.callPackage ./modules/cix_vpu_driver { };
        }
      ));
    };
  };
  linuxPackages_6_6_89 = final.linuxKernel.packages.linux_6_6_89;
  linux_6_6_89 = final.linuxKernel.kernels.linux_6_6_89;
}
