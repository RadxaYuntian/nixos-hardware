{
  lib,
  fetchpatch2,
  fetchFromGitHub,
  buildLinux,
  ...
}@args:

let
  kver = "6.6.89";
  rev = "27aed0850190ca29ce3731127a04e5f398c72afb";
  hash = "sha256-Def0vWwIIXmheERigb5ovDKgSClZxI6wPjxsjkmIjaI=";

  args' =
    {
      version = "${kver}";
      modDirVersion = "${kver}-cix-build";
      pname = "linux-sky1";

      src = fetchFromGitHub {
        owner = "radxa";
        repo = "kernel";
        inherit rev hash;
      };

      defconfig = "defconfig cix.config";

      structuredExtraConfig = with lib.kernel; {
        # Referencing non existing function
        CIX_CORE_CTL = lib.mkForce no;
        # Non existing INV_ICM42600_REG_DRIVE_CONFIG constant
        INV_ICM42600_I2C = lib.mkForce no;
        # NULL dereference panic on reboot
        CIX_DST = lib.mkForce no;
      };

      isLTS = true;

      ignoreConfigErrors = true;
    }
    // (args.argsOverride or { });
in
buildLinux args'
