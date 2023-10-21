
from diffusers import StableDiffusionLDM3DPipeline

pipe = StableDiffusionLDM3DPipeline.from_pretrained("Intel/ldm3d-pano")
pipe.to("cuda")

prompt = "a magic forest"
prompt =f"360 view of {prompt}"
name = "out"

output = pipe(
        prompt,
        width=1024,
        height=512,
        guidance_scale=7.0,
        num_inference_steps=50,
    ) 

rgb_image, depth_image = output.rgb, output.depth
rgb_image[0].save(name+"_ldm3d_rgb.jpg")
depth_image[0].save(name+"_ldm3d_depth.png")
