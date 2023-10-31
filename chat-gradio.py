#!/usr/bin/env python3

import gradio as gr
import time
import torch
from transformers import pipeline

pipe = pipeline(
    "text-generation",
    model="HuggingFaceH4/zephyr-7b-beta",
    torch_dtype=torch.bfloat16,
    device_map="auto",
)


def echo(message, history, system_prompt, max_new_tokens):
    response = f"System prompt: {system_prompt}\n Message: {message}."
    messages = [
        {
            "role": "system",
            "content": system_prompt,
        },
        {"role": "user", "content": message},
    ]
    prompt = pipe.tokenizer.apply_chat_template(
        messages, tokenize=False, add_generation_prompt=True
    )
    outputs = pipe(
        prompt,
        max_new_tokens=max_new_tokens,
        do_sample=True,
        temperature=0.7,
        top_k=50,
        top_p=0.95,
    )
    return outputs[0]["generated_text"]


with gr.Blocks() as demo:
    max_new_tokens = gr.Slider(
        minimum=16, maximum=2048, value=256, step=1, label="Max New Tokens"
    )
    system_prompt = gr.Textbox(
        "You are a friendly chatbot who always responds in the style of a pirate",
        label="System Prompt",
    )
    gr.ChatInterface(echo, additional_inputs=[system_prompt, max_new_tokens])

if __name__ == "__main__":
    demo.queue().launch(server_name="0.0.0.0")
