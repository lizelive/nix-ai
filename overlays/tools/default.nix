final: prev:
let callPackage = final.callPackage; in
rec {
  ktx-software = callPackage ./ktx-software/default.nix { };
  gltf-ibl-sampler = callPackage ./gltf-ibl-sampler/default.nix { };
  trimesh2 = callPackage ./trimesh2 { };
  cuda-voxelizer = callPackage ./cuda-voxelizer { inherit trimesh2; };
  fetch-huggingface = callPackage ./fetch-huggingface { };
  embree217 = callPackage ./embree { };
  blender-bin = callPackage ./blender-bin final;
}
