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

      defconfig = "defconfig cix.config";

      isLTS = true;

      ignoreConfigErrors = true;
    }
    // (args.argsOverride or { });
in
buildLinux args'
