#!/usr/bin/env python3
import torch
import matplotlib
import matplotlib.cm
import numpy as np
from PIL import Image

torch.hub.help(
    "AyaanShah2204/MiDaS", "DPT_BEiT_L_384"
)  # Triggers fresh download of MiDaS repo
model_zoe_n = torch.hub.load("isl-org/ZoeDepth", "ZoeD_NK", pretrained=True).eval()
model_zoe_n = model_zoe_n.to("cuda")


def colorize(
    value,
    vmin=None,
    vmax=None,
    cmap="gray_r",
    invalid_val=-99,
    invalid_mask=None,
    background_color=(128, 128, 128, 255),
    gamma_corrected=False,
    value_transform=None,
):
    if isinstance(value, torch.Tensor):
        value = value.detach().cpu().numpy()

    value = value.squeeze()
    if invalid_mask is None:
        invalid_mask = value == invalid_val
    mask = np.logical_not(invalid_mask)

    # normalize
    vmin = np.percentile(value[mask], 2) if vmin is None else vmin
    vmax = np.percentile(value[mask], 85) if vmax is None else vmax
    if vmin != vmax:
        value = (value - vmin) / (vmax - vmin)  # vmin..vmax
    else:
        # Avoid 0-division
        value = value * 0.0

    # squeeze last dim if it exists
    # grey out the invalid values

    value[invalid_mask] = np.nan
    cmapper = matplotlib.cm.get_cmap(cmap)
    if value_transform:
        value = value_transform(value)
        # value = value / value.max()
    value = cmapper(value, bytes=True)  # (nxmx4)

    # img = value[:, :, :]
    img = value[...]
    img[invalid_mask] = background_color

    # gamma correction
    img = img / 255
    img = np.power(img, 2.2)
    img = img * 255
    img = img.astype(np.uint8)
    img = Image.fromarray(img)
    return img


def get_zoe_depth_map(image):
    with torch.autocast("cuda", enabled=True):
        depth = model_zoe_n.infer_pil(image)
    depth = colorize(depth, cmap="gray_r")
    return depth


from diffusers.utils import load_image

image = load_image(
    "https://media.vogue.fr/photos/62bf04b69a57673c725432f3/3:2/w_1793,h_1195,c_limit/rev-1-Barbie-InstaVert_High_Res_JPEG.jpeg"
)
depth_image = get_zoe_depth_map(image).resize((1088, 896))
depth_image.save("out.png")


import torch
import numpy as np
from PIL import Image

from diffusers import (
    ControlNetModel,
    StableDiffusionXLControlNetPipeline,
    AutoencoderKL,
)
from diffusers.utils import load_image

controlnet = ControlNetModel.from_pretrained(
    "diffusers/controlnet-zoe-depth-sdxl-1.0",
    use_safetensors=True,
    torch_dtype=torch.float16,
).to("cuda")
vae = AutoencoderKL.from_pretrained(
    "madebyollin/sdxl-vae-fp16-fix", torch_dtype=torch.float16
).to("cuda")
pipe = StableDiffusionXLControlNetPipeline.from_pretrained(
    "stabilityai/stable-diffusion-xl-base-1.0",
    controlnet=controlnet,
    vae=vae,
    variant="fp16",
    use_safetensors=True,
    torch_dtype=torch.float16,
).to("cuda")
pipe.enable_model_cpu_offload()


prompt = "pixel-art margot robbie as barbie, in a coupé . low-res, blocky, pixel art style, 8-bit graphics"
negative_prompt = (
    "sloppy, messy, blurry, noisy, highly detailed, ultra textured, photo, realistic"
)
image = load_image(
    "https://media.vogue.fr/photos/62bf04b69a57673c725432f3/3:2/w_1793,h_1195,c_limit/rev-1-Barbie-InstaVert_High_Res_JPEG.jpeg"
)

controlnet_conditioning_scale = 0.55

depth_image = get_zoe_depth_map(image).resize((1088, 896))

generator = torch.Generator("cuda").manual_seed(978364352)
images = pipe(
    prompt,
    image=depth_image,
    num_inference_steps=50,
    controlnet_conditioning_scale=controlnet_conditioning_scale,
    generator=generator,
).images
images[0]

images[0].save(f"pixel-barbie.png")
