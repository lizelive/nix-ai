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

  version = "2.17.7";

  src = fetchFromGitHub {
    owner = "embree";
    repo = "embree";
    rev = "v${version}";
    hash = "sha256-FD/ITZBJnYy1F+x4jLTVTsGsNKy/mS7OYWP06NoHZqc=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];
  
  cmakeFlags = [
    "-DEMBREE_TUTORIALS=OFF"
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
