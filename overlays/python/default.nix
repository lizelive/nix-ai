final: prev:
let
  packageOverrides = python-final: python-prev: with python-final; {
    diffusers = callPackage ./diffusers.nix { };
    pyrender = callPackage ./pyrender.nix { };
    # pydantic = callPackage ./pydantic.nix { };
  };
  # python310 = prev.python310.override { inherit packageOverrides; };
  # python311 = prev.python311.override { inherit packageOverrides; };
  pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [ packageOverrides ];
in
{ inherit pythonPackagesExtensions; }
