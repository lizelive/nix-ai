{ lib
, fetchFromGitHub
, buildPythonPackage
, flit
, pyglet
, autoprop
, more_itertools
, pyyaml
, vecrec
}:

buildPythonPackage rec {
  pname = "glooey";
  version = "0.3.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "kxgames";
    repo = "glooey";
    rev = "v${version}";
    hash = "sha256-hgij0G4G29WvUuwCpJAlG8JpxB706Y+VoXOwjtAFACo=";
  };

  nativeBuildInputs = [
    flit
  ];

  propagatedBuildInputs = [
    pyglet
    autoprop
    more_itertools
    pyyaml
    vecrec
  ];

  pythonImportsCheck = [ "glooey" ];

  meta = with lib; {
    description = "An object-oriented GUI library for pyglet";
    homepage = "https://github.com/kxgames/glooey";
    changelog = "https://github.com/kxgames/glooey/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    mainProgram = "glooey";
  };
}
