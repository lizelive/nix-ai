{ lib
, python3
, fetchFromGitHub
}:

python3.pkgs.buildPythonApplication rec {
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
    python3.pkgs.setuptools
    python3.pkgs.wheel
  ];

  propagatedBuildInputs = with python3.pkgs; [
    numpy
  ];

  passthru.optional-dependencies = with python3.pkgs; {
    all = [
      trimesh
    ];
    easy = [
      chardet
      colorlog
      pyembree # i don't think this is open source
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
      # python-fcl
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
      pymeshlab
      pytest
      pytest-cov
      ruff
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
