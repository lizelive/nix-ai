#!/usr/bin/env python3
import torch
from diffusers import ShapEPipeline

device = torch.device("cuda" if torch.cuda.is_available() else "cpu")

pipe = ShapEPipeline.from_pretrained(
    "openai/shap-e",
    torch_dtype=torch.float16,
    variant="fp16"
    # , use_safetensors=True
)
pipe = pipe.to(device)

guidance_scale = 15.0
prompt = ["the earth", "grappling hook", "grapple hook"]

images = pipe(
    prompt,
    guidance_scale=guidance_scale,
    num_inference_steps=64,
    frame_size=256,
).images

from diffusers.utils import export_to_gif, export_to_ply
import trimesh

for i in range(len(images)):
    export_to_gif(images[i], f"{i:03d}.gif")
    ply_path = export_to_ply(images[i], f"{i:03d}.ply")
    mesh = trimesh.load(ply_path)
    mesh.export(f"{i:03d}.glb", file_type="glb")
