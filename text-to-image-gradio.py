#!/usr/bin/env gradio


import gradio as gr


def load_model():
    from diffusers import DiffusionPipeline
    import torch

    pipeline = DiffusionPipeline.from_pretrained(
        "stabilityai/stable-diffusion-2-1",
        torch_dtype=torch.float16,
        safety_checker=None,
        variant="fp16",
        use_safetensors=True,
    ).to("cuda")
    # pipeline.enable_freeu(b1=1.4, b2=1.6, s1=0.9, s2=0.2)

    pipeline.unet = torch.compile(pipeline.unet, mode="reduce-overhead", fullgraph=True)
    # pipeline.enable_model_cpu_offload()
    return pipeline


pipeline = load_model()


def text_to_image(prompt):
    return pipeline(prompt=prompt).images


with gr.Blocks() as demo:
    prompt = gr.Textbox(label="prompt")
    output = gr.Gallery(label="Output")
    greet_btn = gr.Button("Generate Image")
    greet_btn.click(fn=text_to_image, inputs=prompt, outputs=output, api_name="greet")

if __name__ == "__main__":
    demo.launch()
