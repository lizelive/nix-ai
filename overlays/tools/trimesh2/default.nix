{ lib
, stdenv
, fetchFromGitHub
, libGL
, xorg
, libGLU
,
}:
stdenv.mkDerivation rec {
  pname = "trimesh2";
  version = "2022.03.04";

  propagatedBuildInputs = [ libGL libGLU ];
  buildInputs = [
    xorg.libX11
    xorg.libXcursor
    xorg.libXi
    xorg.libXrandr # To use the x11 feature
  ];

  # nativeBuildInputs = [ pkg-config ];

  src = fetchFromGitHub {
    owner = "Forceflow";
    repo = "trimesh2";
    rev = version;
    hash = "sha256-ivCvlJ0Ct0MpIs6djTKYdOdwqbAvU4qKzm7R/FgPEhk=";
  };

  # outputs = [ "out" "bin" "dev" "includes" ];#

  installPhase = ''
    mkdir -p $out
    cp -r bin.Linux64 $out/bin
    cp -r lib.Linux64 $out/lib
    cp -r include $out/include
  '';

  meta = with lib; {
    description = "C++ library and set of utilities for input, output, and basic manipulation of 3D triangle meshes";
    homepage = "https://github.com/Forceflow/trimesh2";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ lizelive ];
    mainProgram = "trimesh2";
    platforms = platforms.all;
    pkgConfigModules = [ "trimesh2" ];
  };
}
