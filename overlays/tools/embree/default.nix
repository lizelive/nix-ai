{ lib
, stdenv
, fetchFromGitHub
, cmake
, pkg-config
, ispc
, tbb
, glfw
, openimageio2
, libjpeg
, libpng
, libpthreadstubs
, libX11
}:

stdenv.mkDerivation rec {
  pname = "embree";

    # version = "3.2.3";
    # src = fetchFromGitHub {
    #     owner = "embree";
    #     repo = "embree";
    #     rev = "09a6013b79d0a670ca630d121b86265f9b9fab99";
    #     sha256 = "0920asx0d9v0wcxh7wip98db0vhwz3zkwn2glimy7vfsh9nzinwh";
    # };

  version = "4.3.0";

  src = fetchFromGitHub {
    owner = "embree";
    repo = "embree";
    rev = "v${version}";
    hash = "sha256-Mk0xaY7QL6Xe0+pNz725iwMnzcXOsYz9Bm5H7fEj+8o=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [ ispc tbb glfw openimageio2 libjpeg libpng libX11 libpthreadstubs ];


  meta = with lib; {
    description = "Embree ray tracing kernels repository";
    homepage = "https://github.com/embree/embree";
    changelog = "https://github.com/embree/embree/blob/${src.rev}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
    mainProgram = "embree";
    platforms = platforms.all;
  };
}
