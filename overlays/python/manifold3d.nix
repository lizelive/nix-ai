{ lib
, fetchFromGitHub
, buildPythonPackage
, scikit-build-core
, numpy
, cmake
, ninja
}:

buildPythonPackage rec {
  pname = "manifold";
  version = "2.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "elalish";
    repo = "manifold";
    rev = "v${version}";
    hash = "sha256-Kh0X/ieGuniKBCIccgSEJ1I9CpXJzdCLyo0fPthxAI4=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    ninja
    scikit-build-core
  ];

  propagatedBuildInputs = [
    numpy
  ];

  pythonImportsCheck = [ "manifold3d" ];

  meta = with lib; {
    description = "Geometry library for topological robustness";
    homepage = "https://github.com/elalish/manifold";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
    mainProgram = "manifold";
  };
}
