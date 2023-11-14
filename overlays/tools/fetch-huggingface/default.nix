{ stdenvNoCC
, system
, lib
, linkFarm
, python3Packages
, writers
}:

let
  builder = writers.writePython3 "fetch-huggingface"
    {
      libraries = with python3Packages; [
        torch
        transformers
        accelerate
        optimum
        diffusers
        safetensors
      ];
    }
    (builtins.readFile ./__main__.py);

  # args = lib.cli.toGNUCommandLine {} opts;
  # 
  # 
  # script = ./fetch-huggingface.py;
in
inputs @ { model_id, outputHash ? lib.fakeHash, ... }:
let
  opts_json = builtins.toJSON inputs;
  name = builtins.replaceStrings [ "/" ] [ "--" ] model_id;
in
derivation {
  inherit name builder outputHash system;
  outputHashMode = "recursive";
  fetch = opts_json;
  XDG_CACHE_HOME = "$TEMPDIR";
}
