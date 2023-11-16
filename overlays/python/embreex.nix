{ lib
, fetchFromGitHub
, buildPythonPackage
, cython
, numpy
, poetry-core
, setuptools
, wheel
, rtree
, trimesh
, embree217
}:

buildPythonPackage rec {
  pname = "embreex";
  version = "2.17.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "trimesh";
    repo = "embreex";
    rev = version;
    hash = "sha256-MiDagE94qSdTA+zZCKkCSEpvr3J1F+K0TECe8At83y4=";
  };

  nativeBuildInputs = [
    cython
    numpy
    poetry-core
    setuptools
    wheel
    embree217
  ];

  propagatedBuildInputs = [
    cython
    numpy
    rtree
    setuptools
    trimesh
    wheel
  ];

  # it's hardcoding the path to the embree library idk what to do about that

  pythonImportsCheck = [ "embreex" ];

  meta = with lib; {
    description = "Python Wrapper for Embree";
    homepage = "https://github.com/trimesh/embreex";
    license = licenses.bsd2;
    maintainers = with maintainers; [ ];
    mainProgram = "embreex";
  };
}
