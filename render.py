#!/usr/bin/env python3

import os

os.environ["PYOPENGL_PLATFORM"] = "egl"
import numpy as np
import trimesh
import pyrender
import matplotlib.pyplot as plt


SIZE = 2048
r = pyrender.OffscreenRenderer(SIZE, SIZE)

import numpy as np
import trimesh
import pyrender
import matplotlib.pyplot as plt

from PIL import Image


root_url = "http://nook.local/datasets/allenai/objaverse"

object_path_url = f"{root_url}/object-paths.json.gz"


def load_index():
    import gzip
    import json
    import requests

    req = requests.get(object_path_url)
    reqb = gzip.decompress(req.content)
    # convert to string
    reqs = reqb.decode("utf-8")
    object_paths = json.loads(reqs)
    paths = list(object_paths.values())
    return paths


paths = load_index()

# pick random index
import random
import json

# model_index = random.randint(0, len(paths) - 1)
DEPTH_LOG = False
DEPTH_INVERT = False

def handle(model_index):
    # random_index = 1

    mesh_url = f"{root_url}/{paths[model_index]}"
    mesh: trimesh.Trimesh = trimesh.load_remote(mesh_url, force="mesh")
    # assert clean_mesh.fill_holes(), "failed to fill holes"
    # bounds: trimesh.primitives.Sphere = mesh.bounding_sphere
    bounds: trimesh.primitives.Box = mesh.bounding_box
    # bounding_sphere.apply_translation(-bounding_sphere.t)
    # transform = np.linalg.inv(bounds.primitive.transform)
    # print(bounds.transform)
    mesh.apply_translation(-mesh.bounds.mean(axis=0))
    mesh.apply_scale(1 / mesh.extents.max())
    # mesh.apply_scale(1 / bounds.primitive.radius)

    print(mesh_url, mesh.volume)

    with open(f"out/{model_index}.meta.json", "w") as f:
        meta = dict(url=mesh_url, volume=mesh.volume)
        json.dump(meta, f)

    # voxelized = mesh.voxelized(1 / 256)
    # # voxelized_filled = voxelized.fill()

    # with open(f"out/{model_index}.vox.npz", "wb") as f:
    #     np.savez_compressed(f, voxelized=voxelized.matrix)

    for angle in range(0, 360, 90):
        scene = pyrender.Scene(ambient_light=np.ones(3))
        scene.add(pyrender.Mesh.from_trimesh(mesh))
        # camera = pyrender.PerspectiveCamera(yfov=np.pi / 2.0, aspectRatio=1.0)
        mag = 1 / 2
        camera = pyrender.OrthographicCamera(xmag=mag, ymag=mag, zfar=2)
        camera_pose = np.eye(4)
        camera_pose[:3, 3] = [0, 0, 1]
        camera_pose = (
            trimesh.transformations.rotation_matrix(
                angle=np.deg2rad(angle), direction=[0, 1, 0]
            )
            @ camera_pose
        )

        scene.add(camera, pose=camera_pose)
        # light = pyrender.SpotLight(
        #     color=np.ones(3),
        #     intensity=3.0,
        #     innerConeAngle=np.pi / 16.0,
        #     outerConeAngle=np.pi / 6.0,
        # )
        # scene.add(light, pose=camera_pose)
        color, depth = r.render(scene, flags=pyrender.RenderFlags.FACE_NORMALS | pyrender.RenderFlags.OFFSCREEN) 
        color = color.copy()
        # color[:, :, 3] = 255 - color[:, :, 3]
        # color = color.astype(np.float32) / 255

        # out = np.dstack((, depth))
        # print(color.shape, color.dtype)
        # print(color.min(), color.max())

        # print(depth.shape, depth.dtype)
        # print(depth.min(), depth.max())

        with open(f"out/{model_index}.{angle}.npz", "wb") as f:
            np.savez_compressed(f, color=color, depth=depth, camera_pose=camera_pose)

        color = Image.fromarray(color, "RGB")
        # color.save(f"out/{model_index}.{angle}.color.spi", format='SPIDER')
        # color.save(f"out/{model_index}.{angle}.color.jpg")
        # color.save(f"out/{model_index}.{angle}.color.png")
        # color.save(f"out/{model_index}.{angle}.color.j2k")
        color.save(f"out/{model_index}.{angle}.rgb.webp", lossless=True)

        depth -= depth.min()
        depth /= depth.max()
        
        # depth = 1 / ( 1- depth)
        # depth -= depth.min()
        # depth /= depth.max()

        if DEPTH_LOG:
            depth = np.log1p(depth)
            depth -= depth.min()
            depth /= depth.max()
        if DEPTH_INVERT:
            depth = 1 - depth

        depth = (depth * (2**8 - 1)).astype(np.uint8)
        # depth = (depth * (2**16 - 1)).astype(np.uint16)

        print(depth.min(), depth.max(), depth.dtype, depth.shape)
        depth = Image.fromarray(depth, "L")

        depth.save(f"out/{model_index}.{angle}.d.png" )


for model_index in range(5 + 0 * len(paths)):
    try:
        handle(model_index)
    except Exception as e:
        print(model_index, e)
