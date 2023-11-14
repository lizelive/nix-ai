{ lib
, stdenv
, fetchFromGitHub
, pkg-config
, cmake
, zstd
, libGL
, vulkan-loader
, vulkan-headers
, vulkan-tools
, stb
, perl
, shaderc
,
}:
let
  runtimeLibs = [
    libGL
    vulkan-loader
    vulkan-headers
    vulkan-tools
    stb
  ];

  nativeBuildInputs = [
    pkg-config
    cmake
    vulkan-loader
    perl
  ];

  buildInputs = [
    vulkan-headers
    stb
    shaderc
  ];

  owner = "KhronosGroup";
  repo = "KTX-Software";
  version = "4.3.0-alpha3";
  src = fetchFromGitHub {
    inherit owner repo;
    rev = "v${version}";
    hash = "sha256-6ZLjOoWjOI253vtL8K9seOvAIQ8zgQHDw2ZaXvypTLQ=";
    fetchSubmodules = true;
  };
in
stdenv.mkDerivation {
  pname = repo;
  inherit version buildInputs nativeBuildInputs src;

  doCheck = true;

  meta =
    # src.meta //
    with lib; {
      license = licenses.asl20;
      maintainers = with maintainers; [ lizelive ];
      platforms = platforms.linux;
    };
}
