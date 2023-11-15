{ lib
, fetchFromGitHub
, buildPythonPackage
, cython
, numpy
, oldest-supported-numpy
, setuptools
, wheel
}:

buildPythonPackage rec {
  pname = "python-fcl";
  version = "0.7.0.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "BerkeleyAutomation";
    repo = "python-fcl";
    rev = "v${version}";
    hash = "sha256-C0Wmr0cx1dUpdKhBD+ancXHP0Oyt+8AdVCONBGIQGiQ=";
  };

  nativeBuildInputs = [
    cython
    numpy
    oldest-supported-numpy
    setuptools
    wheel
  ];

  pythonImportsCheck = [ "python_fcl" ];

  meta = with lib; {
    description = "Python binding of FCL library";
    homepage = "https://github.com/BerkeleyAutomation/python-fcl";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
    mainProgram = "python-fcl";
  };
}
