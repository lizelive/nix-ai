final: prev:
let
  packageOverrides = python-final: python-prev: with python-final; {
    diffusers = callPackage ./diffusers.nix { };
    pyrender = callPackage ./pyrender.nix { };
    trimesh = callPackage ./trimesh.nix { };
    glooey = callPackage ./glooey.nix { };
    manifold3d = callPackage ./manifold3d.nix { };
    vhacdx = callPackage ./vhacdx.nix { };
    pyembree = callPackage ./pyembree.nix { };
  };
  pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [ packageOverrides ];
in
{ inherit pythonPackagesExtensions; }
