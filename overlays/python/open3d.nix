{ lib
, stdenv
, fetchFromGitHub
, cmake
}:

stdenv.mkDerivation rec {
  pname = "open3d";
  version = "0.17.0";

  # python.requires = [
  #   addict
  #   configargparse
  #   dash
  #   ipywidgets
  #   matplotlib
  #   nbformat
  #   numpy
  #   pandas
  #   pillow
  #   pyquaternion
  #   pyyaml
  #   scikit-learn
  #   tqdm
  #   werkzeug
  # ];

  src = fetchFromGitHub {
    owner = "isl-org";
    repo = "Open3D";
    rev = "v${version}";
    hash = "sha256-dGdDnHch71O7wAbK8Sg+0uH0p99avUtrG/lFmpsx45Y=";
  };

  nativeBuildInputs = [
    cmake
  ];

  meta = with lib; {
    description = "Open3D: A Modern Library for 3D Data Processing";
    homepage = "https://github.com/isl-org/Open3D";
    changelog = "https://github.com/isl-org/Open3D/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    mainProgram = "open3d";
    platforms = platforms.all;
  };
}
