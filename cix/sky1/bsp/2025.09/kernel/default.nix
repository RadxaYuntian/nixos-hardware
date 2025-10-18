{
  lib,
  fetchFromGitHub,
  buildLinux,
  ...
}@args:

let
  kver = "6.6.89";
  rev = "915a940499a619f362d7e4b2203c105313941f88";
  hash = "sha256-d3nVowJlsB26FwRH/lA2b4U2u5orV3SwEvk3xVArrgc=";

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

      kernelPatches = [
        {
          name = "fix-fwnode_regulator";
          patch = ./fix-fwnode_regulator.patch;
        }
        {
          name = "fix-cix-ec";
          patch = ./fix-cix-ec.patch;
        }
        {
          name = "incompatible-pointer";
          patch = ./incompatible-pointer.patch;
        }
      ];

      defconfig = "defconfig cix.config";

      structuredExtraConfig = with lib.kernel; {
        # Referencing non existing function
        CIX_CORE_CTL = lib.mkForce no;
        # drm_gpuvm.h conflict
        DRM_NOUVEAU = lib.mkForce no;
        # Non existing DP_CONF_SIGNALLING_SHIFT constant
        TYPEC_DP_ALTMODE = lib.mkForce no;
        # Non existing INV_ICM42600_REG_DRIVE_CONFIG constant
        INV_ICM42600_I2C = lib.mkForce no;
      };

      isLTS = true;

      ignoreConfigErrors = true;
    }
    // (args.argsOverride or { });
in
buildLinux args'
