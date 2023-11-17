{ lib
, buildPythonPackage
, fetchPypi
, setuptools
, wheel
}:

buildPythonPackage rec {
  pname = "fake-bpy-module-latest";
  version = "20231116";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-7Zo93Bx1pB4JC+6/omniMlGzZiyc7UHsA4RO9HlTy44=";
  };

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  pythonImportsCheck = [ "bpy" ];

  meta = with lib; {
    description = "Collection of the fake Blender Python API module for the code completion";
    homepage = "https://pypi.org/project/fake-bpy-module-latest";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
