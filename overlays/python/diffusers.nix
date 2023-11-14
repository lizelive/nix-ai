{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, # propagated build inputs
  pillow
, filelock
, huggingface-hub
, importlib-metadata
, numpy
, regex
, requests
, safetensors
, # optional dependencies
  torch
, accelerate
, jinja2
, datasets
, protobuf3
, tensorboard
, # test
  pytestCheckHook
, transformers
, black
, parameterized
, requests-mock
, invisible-watermark
, k-diffusion
, librosa
, omegaconf
, pytest
, pytest-timeout
, pytest-xdist
, sentencepiece
, scipy
, torchvision
, # compel, docbuilder, # TODO not in nixpkgs

}:
buildPythonPackage rec {
  pname = "diffusers";
  version = "0.23.0";

  disabled = pythonOlder "3.7.0"; # requires python version >=3.7.0


  src = fetchFromGitHub {
    owner = "huggingface";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-nyKZVnthADMFA2DVlCPLYJUf0R3fV++OzGhjHDJnMI0=";
  };


  pythonImportsCheck = [ pname ];

  meta = with lib; {
    description = "Diffusers: State-of-the-art diffusion models for image and audio generation in PyTorch";
    homepage = "https://github.com/huggingface/diffusers";
    license = licenses.asl20;
    maintainers = with maintainers; [ lizelive natsukium ];
    mainProgram = "diffusers";
  };

  propagatedBuildInputs = [
    pillow
    filelock
    huggingface-hub
    importlib-metadata
    numpy
    regex
    requests
    safetensors
  ];

  doCheck = false;

  nativeCheckInputs = [
    pytestCheckHook
  ];

  # requires additional data
  pytestFlagsArray = [
    "tests/"
    "--tb=line"
    "-rf" # https://docs.pytest.org/en/7.1.x/how-to/output.html#producing-a-detailed-summary-report
    # "--ignore=tests/integration"
  ];

  disabledTests = [
    # touches network
    # "download"
    # "update"
  ];



  disabledTestPaths = [
    "tests/others/test_check_copies.py" # no docbuilder

    # tried to grab stuff
    # "tests/models/test_attention_processor.py"
    # "tests/models/test_lora_layers.py"
    # "tests/models/test_modeling_common.py"
    # "tests/models/test_models_prior.py"
    # "tests/models/test_models_unet_1d.py"
    # "tests/models/test_models_unet_2d_condition.py"
    # "tests/models/test_models_unet_2d.py"
    # "tests/models/test_models_unet_3d_condition.py"
    # "tests/models/test_models_vae.py"
    # "tests/models/test_models_vq.py"
    # "tests/others/test_config.py"
    # "tests/others/test_ema.py"
    # "tests/others/test_utils.py"
    # "tests/pipelines/altdiffusion/test_alt_diffusion_img2img.py"
    # "tests/pipelines/altdiffusion/test_alt_diffusion.py"
    # "tests/pipelines/audioldm2/test_audioldm2.py"
    # "tests/pipelines/audioldm/test_audioldm.py"
    # "tests/pipelines/consistency_models/test_consistency_models.py"
    # "tests/pipelines/controlnet/test_controlnet_img2img.py"
    # "tests/pipelines/controlnet/test_controlnet_inpaint.py"
    # "tests/pipelines/controlnet/test_controlnet_inpaint_sdxl.py"
    # "tests/pipelines/controlnet/test_controlnet.py"
    # "tests/pipelines/controlnet/test_controlnet_sdxl_img2img.py"
    # "tests/pipelines/controlnet/test_controlnet_sdxl.py"
    # "tests/pipelines/deepfloyd_if/test_if_img2img.py"
    # "tests/pipelines/deepfloyd_if/test_if_img2img_superresolution.py"
    # "tests/pipelines/deepfloyd_if/test_if_inpainting.py"
    # "tests/pipelines/deepfloyd_if/test_if_inpainting_superresolution.py"
    # "tests/pipelines/deepfloyd_if/test_if.py"
    # "tests/pipelines/deepfloyd_if/test_if_superresolution.py"
    # "tests/pipelines/kandinsky/test_kandinsky_combined.py"
    # "tests/pipelines/kandinsky/test_kandinsky_img2img.py"
    # "tests/pipelines/kandinsky/test_kandinsky_inpaint.py"
    # "tests/pipelines/kandinsky/test_kandinsky_prior.py"
    # "tests/pipelines/kandinsky/test_kandinsky.py"
    # "tests/pipelines/kandinsky_v22/test_kandinsky_combined.py"
    # "tests/pipelines/kandinsky_v22/test_kandinsky_prior_emb2emb.py"
    # "tests/pipelines/kandinsky_v22/test_kandinsky_prior.py"
    # "tests/pipelines/test_pipelines_auto.py"
    # "tests/pipelines/test_pipelines_combined.py"
    # "tests/pipelines/test_pipelines.py"

  ];

  checkInputs = [
    transformers
    torchvision
    torch
    sentencepiece
    scipy
    requests-mock
    pytest-xdist
    pytest-timeout
    pytest
    parameterized
    omegaconf
    librosa
    k-diffusion
    jinja2
    invisible-watermark
    huggingface-hub
    datasets

    black
    accelerate
    # compel docbuilder # not in nixpkgs
  ];

  XDG_CACHE_HOME = "$TEMPDIR";

  passthru.optional-dependencies = {
    torch = [
      torch
      accelerate
    ];
    training = [
      jinja2
      accelerate
      datasets
      protobuf3
      tensorboard
    ];
  };

}
