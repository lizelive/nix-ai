#!/usr/bin/env python3
from optimum.onnxruntime import ORTStableDiffusionPipeline

model_id = "runwayml/stable-diffusion-v1-5"
pipeline = ORTStableDiffusionPipeline.from_pretrained(model_id, revision="onnx")
prompt = "sailing ship in storm by Leonardo da Vinci"
image = pipeline(prompt).images[0]
