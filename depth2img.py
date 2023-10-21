#!/usr/bin/env python3
import torch
import requests
from PIL import Image
from diffusers import StableDiffusionDepth2ImgPipeline

pipe = StableDiffusionDepth2ImgPipeline.from_pretrained(
   "stabilityai/stable-diffusion-2-depth",
   variant="fp16",
   use_safetensors = True,
   torch_dtype=torch.float16
).to("cuda")

init_image = Image.open("input.png").convert("RGB").resize((512, 512))

prompt = "spaceship"
n_propmt = "bad, deformed, ugly, bad anotomy"
generator = torch.Generator("cuda").manual_seed(0)
image = pipe(prompt=prompt, generator=generator, image=init_image, negative_prompt=n_propmt, strength=0.7).images[0]
image.save("out.png")

memory_usage = torch.cuda.memory_stats()["allocated_bytes.all.peak"]
print(f"Memory usage: {memory_usage / 1024 ** 3:.03f} GB")  