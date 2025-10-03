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

      defconfig = "defconfig cix.config";

      isLTS = true;

      ignoreConfigErrors = true;
    }
    // (args.argsOverride or { });
in
buildLinux args'
