# Radxa Orion O6 Series

Radxa Orion O6 series consistes multiple single board computers based on CIX P1 SoC:

* Radxa Orion O6
* Radxa Orion O6N

Notably, CIX P1 SoC supports UEFI and ACPI, allowing a single image to work on
all products. As such, we made an exception to support this family in `nixos-hardware`
with vendor BSP packages.

As we expect to see multiple BSP releases in relatively quick succession, a special
option `hardware.cix.sky1.bspRelease` has been added. It can be used to select
a specific BSP release to be used on the system. Along with NixOS
[`specialisation`](https://wiki.nixos.org/wiki/Specialisation), users can maintain
several BSP (and even upstream kernel) boot entries in the system, and easily
switch between them to help troubleshooting.

This `nixos-hardware` module is intended to support all Radxa CIX P1-based products.
