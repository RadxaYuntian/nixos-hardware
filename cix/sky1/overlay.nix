final: _prev: {
  linuxKernel = _prev.linuxKernel // {
    kernels = _prev.linuxKernel.kernels // {
      linux_cix = final.callPackage ./kernel {
        linux = _prev.linux_6_18;
        branch = "6.18";
      };
      linux_latest_cix = final.callPackage ./kernel {
        linux = _prev.linux_testing;
        branch = "7.0";
      };
    };

    vanillaPackages = _prev.linuxKernel.vanillaPackages // {
      linux_cix = final.lib.recurseIntoAttrs (
        (final.linuxKernel.packagesFor final.linuxKernel.kernels.linux_cix).extend (
          _: _: {
            cix_vpu_driver = final.linuxKernel.packages.linux_cix.callPackage ./modules/cix_vpu_driver { };
            cix_npu_driver = final.linuxKernel.packages.linux_cix.callPackage ./modules/cix_npu_driver { };
          }
        )
      );
      linux_latest_cix = final.lib.recurseIntoAttrs (
        (final.linuxKernel.packagesFor final.linuxKernel.kernels.linux_latest_cix).extend (
          _: _: {
            cix_vpu_driver =
              final.linuxKernel.packages.linux_latest_cix.callPackage ./modules/cix_vpu_driver
                { };
            cix_npu_driver =
              final.linuxKernel.packages.linux_latest_cix.callPackage ./modules/cix_npu_driver
                { };
          }
        )
      );
    };
  };

  linuxPackages_cix = final.linuxKernel.packages.linux_cix;
  linux_cix = final.linuxKernel.kernels.linux_cix;

  linuxPackages_latest_cix = final.linuxKernel.packages.linux_latest_cix;
  linux_latest_cix = final.linuxKernel.kernels.linux_latest_cix;

  cix_vaapi_driver = final.callPackage ./pkgs/cix_vaapi_driver { };
  cix_libva = final.callPackage ./pkgs/cix_libva { };
}
