{ lib
, stdenv
, fetchFromGitHub
, pkg-config
, cmake
, makeWrapper
, expat
, fontconfig
, freetype
, libGL
, systemd
, vulkan-loader
, vulkan-headers
, vulkan-tools
, xorg
, stb
,
}:
let
  runtimeLibs = [
    fontconfig
    libGL
    vulkan-loader
    xorg.libX11
    xorg.libXcursor
    xorg.libXi
    xorg.libXrandr
    vulkan-headers
    vulkan-tools
    stb
  ];

  nativeBuildInputs = [
    pkg-config
    cmake
    makeWrapper
    vulkan-loader
  ];

  buildInputs = [
    vulkan-headers
    stb
  ];

  owner = "KhronosGroup";
  repo = "glTF-IBL-Sampler";
  binName = "cli";
in
stdenv.mkDerivation {
  pname = repo;
  version = "0.0.1";

  src = fetchFromGitHub {
    inherit owner repo;
    rev = "4248407b4e4d49bec54f42e62b2743ca483dbc89";
    hash = "sha256-XOs4UL2hIX54j8c+wPtk2lgzWP7BdbsD/umVnDVOeKM=";
    fetchSubmodules = true;
  };

  patches = [
    ./22.patch
  ];

  inherit buildInputs nativeBuildInputs;

  postInstall = ''
    wrapProgram $out/bin/cli --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [vulkan-loader]}"
  '';

  doCheck = true;

  meta = with lib; {
    description = "Sampler to create the glTF sample environments ";
    homepage = "https://github.com/KhronosGroup/glTF-IBL-Sampler";
    license = licenses.asl20;
    maintainers = with maintainers; [ lizelive ];
    platforms = platforms.linux;
  };
}
