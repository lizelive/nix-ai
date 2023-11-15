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
  ];

  propagatedBuildInputs = [
    cython
    numpy
    rtree
    setuptools
    trimesh
    wheel
  ];

  pythonImportsCheck = [ "embreex" ];

  meta = with lib; {
    description = "Python Wrapper for Embree";
    homepage = "https://github.com/adam-grant-hendry/pyembree";
    changelog = "https://github.com/adam-grant-hendry/pyembree/blob/${src.rev}/CHANGELOG.rst";
    license = licenses.bsd2;
    maintainers = with maintainers; [ ];
    mainProgram = "embreex";
  };
}
