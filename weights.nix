{ fetchgit, linkFarm }:
let
  models = {
    stable-diffusion-2-depth = {
      owner = "stabilityai";
      repository = "stable-diffusion-2-depth";
      hash = "sha256-0+z3KoJQ58cD7mpOCXQMwByJwX7zO0PO+9fiXTTmf80=";
    };
    controlnet-zoe-depth-sdxl = {
      owner = "diffusers";
      repository = "controlnet-zoe-depth-sdxl-1.0";
      hash = "sha256-SEnPyemY0okb6Qh+bw+adC8kVwgsDxu8+wmd5pQZzSE=";
    };
    stable-diffusion-xl-base = {
      owner = "stabilityai";
      repository = "stable-diffusion-xl-base-1.0";
      hash = "sha256-TBJnIef7Mu65LXbV8TclS702vpxUv4XimCsLUzH5u1c=";
    };
    stable-diffusion-xl-refiner = {
      owner = "stabilityai";
      repository = "stable-diffusion-xl-refiner-1.0";
      hash = "sha256-xQ0rVFY/TuQfLiz1XTLR1L/J9RwgyEwr20nxsbH3+V0=";
    };
  };
  fetchHuggingface =
    { owner
    , repository
    , hash ? ""
    ,
    }: (
      let
        url = "https://huggingface.co/${owner}/${repository}";

      in
      fetchgit {
        url = url;
        hash = hash;
        fetchLFS = true;
      }
    );
  weights = builtins.mapAttrs (name: value: (fetchHuggingface value)) models;
  wl = builtins.attrValues (builtins.mapAttrs (name: path: builtins.trace name { inherit name path; }) weights);
  combined = linkFarm "weights" wl;
in
{ inherit weights combined; }
