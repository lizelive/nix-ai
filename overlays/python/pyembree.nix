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
  pname = "pyembree";
  version = "0.2.11";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "adam-grant-hendry";
    repo = "pyembree";
    rev = version;
    hash = "sha256-i+biTvLV+D5XG7Y7sflwAjaxNw4lCdJfOk19YeoYR1o=";
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

  pythonImportsCheck = [ "pyembree" ];

  meta = with lib; {
    description = "Python Wrapper for Embree";
    homepage = "https://github.com/adam-grant-hendry/pyembree";
    changelog = "https://github.com/adam-grant-hendry/pyembree/blob/${src.rev}/CHANGELOG.rst";
    license = licenses.bsd2;
    maintainers = with maintainers; [ ];
    mainProgram = "pyembree";
  };
}