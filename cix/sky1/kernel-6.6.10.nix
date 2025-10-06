{
  lib,
  fetchFromGitHub,
  buildLinux,
  ...
}@args:

let
  kver = "6.6.10";
  rev = "2add29681c35339e7d80169a670d301bb06ab277";
  hash = "sha256-32U5u6R+ClKcrdFDkGv/H381+VFUmDCzAXoPXu3Ybus=";

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
        # Referencing non existing funciton
        CIX_CORE_CTL = lib.mkForce no;
        # Conflicting with CONFIG_SND_HDACODEC_REALTEK
        SND_HDA = lib.mkForce no;
        SND_HDA_CODEC_REALTEK = lib.mkForce no;
        # Extra SND_HDA dependents
        SND_HDA_TEGRA = lib.mkForce no;
        SND_HDA_INTEL = lib.mkForce no;
        SND_SOC_HDA = lib.mkForce no;
      };

      isLTS = true;

      ignoreConfigErrors = true;
    }
    // (args.argsOverride or { });
in
buildLinux args'
