final: _prev: {
  linuxKernel = _prev.linuxKernel // {
    kernels = _prev.linuxKernel.kernels // {
      linux_6_6_10 = final.callPackage ./linux-6.6.10.nix {};
      linux_6_6_89 = final.callPackage ./linux-6.6.89.nix {};
    };
    vanillaPackages = _prev.linuxKernel.vanillaPackages // {
      linux_6_6_10 = final.recurseIntoAttrs (final.linuxKernel.packagesFor final.linuxKernel.kernels.linux_6_6_10);
      linux_6_6_89 = final.recurseIntoAttrs (final.linuxKernel.packagesFor final.linuxKernel.kernels.linux_6_6_89);
    };
  };
  linuxPackages_6_6_10 = final.linuxKernel.packages.linux_6_6_10;
  linuxPackages_6_6_89 = final.linuxKernel.packages.linux_6_6_89;
}
