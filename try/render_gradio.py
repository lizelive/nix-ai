#!/usr/bin/env gradio
import gradio as gr
import os


def load_mesh(mesh_file_name):
    return mesh_file_name


demo = gr.Interface(
    fn=load_mesh,
    inputs=gr.Model3D(
        raw={"is_file": False, "data": media_data.BASE64_MODEL3D},
        serialized="https://github.com/gradio-app/gradio/raw/main/test/test_files/Box.gltf",
    ),
    outputs=gr.Model3D(clear_color=[0.0, 0.0, 0.0, 0.0], label="3D Model"),
    examples=[
        # ["http://nook.lize.live/datasets/allenai/objaverse/glbs/000-110/604554ac79014d969f7149d65e49d7ff.glb"]
    ],
)

if __name__ == "__main__":
    demo.launch()
