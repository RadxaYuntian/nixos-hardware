{
  stdenv,
  lib,
  fetchFromGitHub,
  meson,
  pkg-config,
  ninja,
  wayland-scanner,
  libdrm,
  minimal ? false,
  libx11,
  libxcb,
  libxext,
  libxfixes,
  wayland,
  libffi,
  libGL,
  mesa,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cix_libva" + lib.optionalString minimal "-minimal";
  version = "2026.Q1";

  src = fetchFromGitHub {
    owner = "cixtech";
    repo = "cix_libva";
    rev = "df051ea3dbf28137f8c0e474085b336ca4aa8a24";
    sha256 = "sha256-mUZytTDz5VnjmeM3CxcgdiNSGNyfRPCfq+Zkclj1VKg=";
  };

  outputs = [
    "dev"
    "out"
  ];

  depsBuildBuild = [ pkg-config ];

  nativeBuildInputs = [
    meson
    pkg-config
    ninja
  ]
  ++ lib.optional (!minimal) wayland-scanner;

  buildInputs = [
    libdrm
  ]
  ++ lib.optionals (!minimal) [
    libx11
    libxcb
    libxext
    libxfixes
    wayland
    libffi
    libGL
  ];

  mesonFlags = lib.optionals stdenv.hostPlatform.isLinux [
    # Add FHS and Debian paths for non-NixOS applications
    "-Ddriverdir=${mesa.driverLink}/lib/dri:/usr/lib/dri:/usr/lib32/dri:/usr/lib/x86_64-linux-gnu/dri:/usr/lib/i386-linux-gnu/dri"
  ];

  env =
    lib.optionalAttrs (stdenv.cc.bintools.isLLVM && lib.versionAtLeast stdenv.cc.bintools.version "17")
      {
        NIX_LDFLAGS = "--undefined-version";
      }
    // lib.optionalAttrs (stdenv.targetPlatform.useLLVM or false) {
      NIX_CFLAGS_COMPILE = "-DHAVE_SECURE_GETENV";
    };

  meta = {
    homepage = "https://github.com/cixtech/cix_libva";
    description = "CIX libva library";
    license = lib.licenses.mit;
    pkgConfigModules = [
      "libva"
      "libva-drm"
    ]
    ++ lib.optionals (!minimal) [
      "libva-glx"
      "libva-wayland"
      "libva-x11"
    ];
    platforms = lib.platforms.linux;
    badPlatforms = [
      # Mandatory libva shared library.
      lib.systems.inspect.platformPatterns.isStatic
    ];
  };
})
