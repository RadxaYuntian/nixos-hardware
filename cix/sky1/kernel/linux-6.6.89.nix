{
  lib,
  fetchFromGitHub,
  buildLinux,
  ...
}@args:

let
  kver = "6.6.89";
  rev = "fd1a9d06cef85f16a4dcb16061a9128437e235f4";
  hash = "sha256-Qiersi0FZ77XK1dAXcxhIh3jkvR2S0dnfOcSrvGNCP4=";

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
