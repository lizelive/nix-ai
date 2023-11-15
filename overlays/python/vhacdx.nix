{ lib
, python3
, fetchFromGitHub
}:

python3.pkgs.buildPythonApplication rec {
  pname = "vhacdx";
  version = "0.0.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "trimesh";
    repo = "vhacdx";
    rev = "3d2c37b9b26e5d3255f0795e5b98d04ced1a4b19";
    hash = "sha256-An7UOapfZjbDuZjgPIPPGFznW5D1xPVrG0/x+O3uWgA=";
  };

  nativeBuildInputs = [
    python3.pkgs.pybind11
    python3.pkgs.setuptools
    python3.pkgs.wheel
  ];

  propagatedBuildInputs = with python3.pkgs; [
    numpy
  ];

  pythonImportsCheck = [ "vhacdx" ];

  meta = with lib; {
    description = "Python bindings for V-HACD";
    homepage = "https://github.com/trimesh/vhacdx";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    mainProgram = "vhacdx";
  };
}
