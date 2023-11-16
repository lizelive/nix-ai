{ lib
, fetchFromGitHub
, buildPythonPackage
, setuptools
, wheel
, numpy
, chardet
, colorlog
, jsonschema
, lxml
, mapbox-earcut
, networkx
, pillow
, pycollada
, requests
, rtree
, scipy
, shapely
, svg-path
, xxhash
, glooey
, manifold3d
, meshio
, psutil
, pyglet
, python-fcl
, scikit-image
, sympy
, vhacdx
, black
, coveralls
, ezdxf
, matplotlib
, mypy
, pyinstrument
, pytest
, pytest-cov
, embreex
}:

buildPythonPackage rec {
  pname = "trimesh";
  version = "4.0.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mikedh";
    repo = "trimesh";
    rev = version;
    hash = "sha256-LGyI/X7IjwfZz6+t/lX/Ve1POti6duYlwMAV6m2oIvA=";
  };

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  propagatedBuildInputs = [
    numpy
  ];

  passthru.optional-dependencies = {

    easy = [
      chardet
      colorlog
      embreex
      jsonschema
      lxml
      mapbox-earcut
      networkx
      pillow
      pycollada
      requests
      rtree
      scipy
      setuptools
      shapely
      svg-path
      xxhash
    ];
    recommend = [
      glooey
      manifold3d
      meshio
      psutil
      pyglet
      python-fcl
      scikit-image
      sympy
      vhacdx
      # xatlas # create uv maps
    ];
    test = [
      black
      coveralls
      ezdxf
      matplotlib
      mypy
      pyinstrument
      pytest
      pytest-cov
    ];
  };

  pythonImportsCheck = [ "trimesh" ];

  meta = with lib; {
    description = "Python library for loading and using triangular meshes";
    homepage = "https://github.com/mikedh/trimesh";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    mainProgram = "trimesh";
  };
}
