{ lib
, stdenv
, buildPythonPackage
, autoflake
, cython
, devtools
, email-validator
, fetchFromGitHub
, fetchpatch
, pytest-mock
, pytestCheckHook
, python-dotenv
, pythonAtLeast
, pythonOlder
, pyupgrade
, typing-extensions
  # dependencies for building documentation.
  # docs fail to build in Darwin sandbox: https://github.com/samuelcolvin/pydantic/issues/4245
, withDocs ? (stdenv.hostPlatform == stdenv.buildPlatform && !stdenv.isDarwin && pythonAtLeast "3.10")
, ansi2html
, markdown-include
, mike
, mkdocs
, mkdocs-exclude
, mkdocs-material
, mdx-truly-sane-lists
, sqlalchemy
, ujson
, orjson
, hypothesis
, libxcrypt
, pdm
}:

buildPythonPackage rec {
  pname = "pydantic";
  version = "2.4.2";
  format = "setuptools";

  outputs = [
    "out"
  ] ++ lib.optionals withDocs [
    "doc"
  ];

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "pydantic";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-aW81VQRXFt4fxEyn3hV390ibvgrCCNqRRDPvbj8dMxU=";
  };

  patches = [
    # Fixes racy doctests build failures on really fast machines
    # FIXME: remove after next release
  ];

  postPatch = ''
    sed -i '/flake8/ d' Makefile
  '';

  buildInputs = lib.optionals (pythonOlder "3.9") [
    libxcrypt
  ];

  nativeBuildInputs = [
    cython
    pdm
  ] ++ lib.optionals withDocs [
    # dependencies for building documentation
    autoflake
    ansi2html
    markdown-include
    mdx-truly-sane-lists
    mike
    mkdocs
    mkdocs-exclude
    mkdocs-material
    sqlalchemy
    ujson
    orjson
    hypothesis
  ];

  propagatedBuildInputs = [
    devtools
    pyupgrade
    typing-extensions
  ];

  passthru.optional-dependencies = {
    dotenv = [
      python-dotenv
    ];
    email = [
      email-validator
    ];
  };

  nativeCheckInputs = [
    pytest-mock
    pytestCheckHook
  ] ++ lib.flatten (lib.attrValues passthru.optional-dependencies);

  pytestFlagsArray = [
    # https://github.com/pydantic/pydantic/issues/4817
    "-W"
    "ignore::pytest.PytestReturnNotNoneWarning"
  ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  # Must include current directory into PYTHONPATH, since documentation
  # building process expects "import pydantic" to work.
  preBuild = lib.optionalString withDocs ''
    PYTHONPATH=$PWD:$PYTHONPATH make docs
  '';

  # Layout documentation in same way as "sphinxHook" does.
  postInstall = lib.optionalString withDocs ''
    mkdir -p $out/share/doc/$name
    mv ./site $out/share/doc/$name/html
  '';

  enableParallelBuilding = true;

  pythonImportsCheck = [ "pydantic" ];

  meta = with lib; {
    description = "Data validation and settings management using Python type hinting";
    homepage = "https://github.com/pydantic/pydantic";
    changelog = "https://github.com/pydantic/pydantic/blob/v${version}/HISTORY.md";
    license = licenses.mit;
    maintainers = with maintainers; [ wd15 ];
  };
}