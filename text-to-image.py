#!/usr/bin/env python3
from diffusers import AutoPipelineForText2Image
import torch

pipeline = AutoPipelineForText2Image.from_pretrained(
    "stabilityai/stable-diffusion-xl-base-1.0", torch_dtype=torch.float16, variant="fp16", use_safetensors =True
).to("cuda")

# pipeline.unet = torch.compile(pipeline.unet, mode="reduce-overhead", fullgraph=True)
pipeline.enable_model_cpu_offload()

prompt = "MKUltra, cold color palette, muted colors, detailed, 8k"
image = pipeline(prompt=prompt).images[0]

image.save("mkultra.png")