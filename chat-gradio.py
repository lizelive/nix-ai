#!/usr/bin/env python3

import gradio as gr
import time
import torch
from transformers import pipeline
from collections import namedtuple

pipe = pipeline(
    "text-generation",
    model="HuggingFaceH4/zephyr-7b-beta",
    torch_dtype=torch.bfloat16,
    device_map="auto",
)


# def pipe(f, *args, **kwargs):
#     return [dict(generated_text=f)]

# def _pipe_tokenizer_apply_chat_template(x, *args, **kwargs):
#     return x

# pipe.tokenizer = namedtuple('tokenizer', 'apply_chat_template')(apply_chat_template=_pipe_tokenizer_apply_chat_template)

def echo(message, history, system_prompt, max_new_tokens):
    print("echo", message, history, system_prompt, max_new_tokens)
    messages = [
        {
            "role": "system",
            "content": system_prompt,
        },
        *[
            h
            for [user, assistant] in history
            for h in [
                {"role": "user", "content": user},
                {"role": "assistant", "content": assistant},
            ]
        ],
        {"role": "user", "content": message},
    ]
    prompt = pipe.tokenizer.apply_chat_template(
        messages, tokenize=False, add_generation_prompt=True
    ) + "<|assistant|>"
    outputs = pipe(
        prompt,
        max_new_tokens=max_new_tokens,
        do_sample=True,
        temperature=0.7,
        top_k=50,
        top_p=0.95,
    )
    generated_text:str = outputs[0]["generated_text"]
    # trim off prompt
    generated_text = generated_text[len(prompt) :]

    generated_text = generated_text.removeprefix("<|assistant|>")
    generated_text = generated_text.strip()
    return generated_text


max_new_tokens = gr.Slider(
    minimum=16, maximum=2048, value=256, step=1, label="Max New Tokens"
)
system_prompt = gr.Textbox(
    "You are a friendly chatbot who always responds in the style of a pirate",
    label="System Prompt",
)
demo = gr.ChatInterface(echo, additional_inputs=[system_prompt, max_new_tokens])

if __name__ == "__main__":
    demo.queue().launch(server_name="[::]")
