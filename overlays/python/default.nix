final: prev:
let
  packageOverrides = python-final: python-prev: with python-final; {
    diffusers = callPackage ./diffusers.nix { };
    glooey = callPackage ./glooey.nix { };
    manifold3d = callPackage ./manifold3d.nix { };
    pyembree = callPackage ./pyembree.nix { };
    pyrender = callPackage ./pyrender.nix { };
    trimesh = callPackage ./trimesh.nix { };
    python-fcl = callPackage ./python-fcl.nix { };
    vhacdx = callPackage ./vhacdx.nix { };
  };

  pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [ packageOverrides ];
in
{ inherit pythonPackagesExtensions; }
