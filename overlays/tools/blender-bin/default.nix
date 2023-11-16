pkgs:
let
  mkBlender = { pname, version, src }:
    with pkgs;

    let
      libs =
        [ wayland libdecor xorg.libX11 xorg.libXi xorg.libXxf86vm xorg.libXfixes xorg.libXrender libxkbcommon libGLU libglvnd numactl SDL2 libdrm ocl-icd stdenv.cc.cc.lib ]
        ++ lib.optionals (lib.versionAtLeast version "3.5") [ xorg.libSM xorg.libICE zlib ];
    in

    stdenv.mkDerivation rec {
      inherit pname version src;

      buildInputs = [ makeWrapper ];

      preUnpack =
        ''
          mkdir -p $out/libexec
          cd $out/libexec
        '';

      installPhase =
        ''
          cd $out/libexec
          mv blender-* blender

          mkdir -p $out/share/applications
          mv ./blender/blender.desktop $out/share/applications/blender.desktop

          mkdir $out/bin

          makeWrapper $out/libexec/blender/blender $out/bin/blender \
            --prefix LD_LIBRARY_PATH : /run/opengl-driver/lib:${lib.makeLibraryPath libs}

          patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
            blender/blender

          patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)"  \
            $out/libexec/blender/*/python/bin/python3*
        '';

      meta.mainProgram = "blender";
    };



in
mkBlender {
  pname = "blender-bin";
  version = "4.1.0";
  src = pkgs.fetchurl {
    url = "https://builder.blender.org/download/daily/blender-4.1.0-alpha+main.d0c073898a93-linux.x86_64-release.tar.xz";
    hash = "sha256-QFKZb1xSl8krWtRCwjCPnd9Bd7FVroU0S1EIrU4oNyk=";
  };
}
