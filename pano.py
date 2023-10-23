#!/usr/bin/env python3
import torch
from diffusers import StableDiffusionPanoramaPipeline, DDIMScheduler

model_ckpt = "stabilityai/stable-diffusion-2-base"
scheduler = DDIMScheduler.from_pretrained(model_ckpt, subfolder="scheduler")
pipe = StableDiffusionPanoramaPipeline.from_pretrained(model_ckpt, variant="fp16", scheduler=scheduler, torch_dtype=torch.float16)

pipe = pipe.to("cuda")

prompt = "a photo of MKUltra"
image = pipe(prompt, circular_padding=True).images[0]
image.save("dolomites.png")
