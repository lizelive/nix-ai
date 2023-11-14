{ lib
, stdenv
, fetchFromGitHub
, pkg-config
, cmake
, vulkan-loader
, vulkan-headers
, stb
, perl
, shaderc
, cudatoolkit
, llvmPackages
, trimesh2
,
}:
let
  nativeBuildInputs = [
    pkg-config
    cmake
    vulkan-loader
    perl
    cudatoolkit
    llvmPackages.openmp
  ];

  buildInputs = [
    vulkan-headers
    stb
    shaderc
    trimesh2
  ];

  owner = "Forceflow";
  repo = "cuda_voxelizer";
  version = "0.6";
  src = fetchFromGitHub {
    inherit owner repo;
    rev = "v${version}";
    hash = "sha256-L/aN/s2qsogcbB22V0YRQR5urCSBiGp2cOpwe9NOoy0=";
    fetchSubmodules = true;
  };
  CUDA_ARCHS = "86;89";
in
stdenv.mkDerivation {
  pname = repo;
  inherit version buildInputs nativeBuildInputs src;

  # doCheck = true;
  # CUDAARCHS=CUDA_ARCHS;

  cmakeFlags = [
    "-DTrimesh2_INCLUDE_DIR:PATH=${trimesh2}/include"
    "-DTrimesh2_LINK_DIR:PATH=${trimesh2}/lib"
    "-DCUDA_ARCH:STRING=${CUDA_ARCHS}"
  ];

  installPhase = ''
    mkdir -p $out/bin
    cp -r cuda_voxelizer $out/bin/
  '';

  meta =
    # src.meta //
    with lib; {
      license = licenses.asl20;
      maintainers = with maintainers; [ lizelive ];
      platforms = platforms.linux;
    };
}
