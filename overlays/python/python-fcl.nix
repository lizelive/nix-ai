{ lib
, python3
, fetchFromGitHub
}:

python3.pkgs.buildPythonApplication rec {
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
    python3.pkgs.cython
    python3.pkgs.numpy
    python3.pkgs.oldest-supported-numpy
    python3.pkgs.setuptools
    python3.pkgs.wheel
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
