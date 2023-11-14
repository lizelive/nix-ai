pkgs: with pkgs; linkFarm "weights"
{
  sdxl-vae = fetch-huggingface {
    kind = "diffusers.AutoencoderKL";
    model_id = "stabilityai/sdxl-vae";
    revision = "6f5909a7e596173e25d4e97b07fd19cdf9611c76";
    outputHash = "sha256-FAhDMDGYY+fgBpY8wS78xM7f0yuj7oCxltvuS2F/Y38=";
  };

  ldm3d-pano = fetch-huggingface {
    kind = "diffusers.DiffusionPipeline";
    model_id = "Intel/ldm3d-pano";
    revision = "58e39b8d2d565d49890e09b93d8f36446ea71aa8";
    outputHash = "sha256-41wMfSjuhcKfqqjd6J3LXh7fVMaWEwYguYjOhaeBm7I=";
  };

  # ldm3d-sr = fetch-huggingface {
  #   kind = "diffusers.DiffusionPipeline";
  #   model_id = "Intel/ldm3d-sr";
  #   revision = "f90e4dcbedb403806be6251be464f129a2c06230";
  #   # outputHash = "";
  # };

  ldm3d-4c = fetch-huggingface {
    kind = "diffusers.DiffusionPipeline";
    model_id = "Intel/ldm3d-4c";
    revision = "c61df5944790246eb34d23562d953852567be9a3";
    outputHash = "sha256-qeod0dvISbzQzEiuG4vADFnZ46pg5o9lOCcpH4IOfKo=";
  };

  dpt-large = fetch-huggingface {
    kind = "transformers.AutoModelForDepthEstimation";
    model_id = "Intel/dpt-large";
    revision = "979c319c3c0482a628979b7b1c7623c16f8892ae";
    outputHash = "sha256-c+sWttZYctxBDPw4GD/rlc46W05jLdJRiH7f4gozNi0=";
  };
}
