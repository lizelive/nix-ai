#!/usr/bin/env python3

import os

os.environ["PYOPENGL_PLATFORM"] = "egl"
import numpy as np
import trimesh
import pyrender
import matplotlib.pyplot as plt


SIZE = 512
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


def handle(model_index):
    # random_index = 1

    mesh_url = f"{root_url}/{paths[model_index]}"
    mesh: trimesh.Trimesh = trimesh.load_remote(mesh_url, force="mesh")
    # assert clean_mesh.fill_holes(), "failed to fill holes"
    bounds: trimesh.primitives.Sphere = mesh.bounding_sphere
    # bounding_sphere.apply_translation(-bounding_sphere.t)
    transform = np.linalg.inv(bounds.primitive.transform)
    print(bounds.center)
    mesh.apply_translation(-bounds.center)
    mesh.apply_scale(1 / bounds.primitive.radius)

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
        camera = pyrender.PerspectiveCamera(yfov=np.pi / 2.0, aspectRatio=1.0)
        camera = pyrender.OrthographicCamera(xmag=1.0, ymag=1.0)
        camera_pose = np.eye(4)
        camera_pose[2, 3] = 2
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
        color, depth = r.render(scene)

        # print(color.shape, color.dtype)
        # print(color.min(), color.max())

        # print(depth.shape, depth.dtype)
        # print(depth.min(), depth.max())

        with open(f"out/{model_index}.{angle}.npz", "wb") as f:
            np.savez_compressed(f, color=color, depth=depth, camera_pose=camera_pose)

        color = Image.fromarray(color, "RGB")
        color.save(f"out/{model_index}.{angle}.color.png")

        # # depth = (depth * (2**8 - 1)).astype("uint8")
        # depth = Image.fromarray(depth, "L")

        # depth.save(f"out/{model_index}.{angle}.depth.png")


for model_index in range(5 + 0 * len(paths)):
    try:
        handle(model_index)
    except Exception as e:
        print(model_index, e)
