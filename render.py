#!/usr/bin/env python3

import os
os.environ['PYOPENGL_PLATFORM'] = 'egl'
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

fuze_trimesh = trimesh.load(
    "/home/lizelive/Documents/cthulhu-space-program/assets/models/doc.glb"
)
scene = pyrender.Scene.from_trimesh_scene(fuze_trimesh)
camera = pyrender.PerspectiveCamera(yfov=np.pi / 3.0, aspectRatio=1.0)
s = np.sqrt(2) / 2
camera_pose = np.array(
    [
        [0.0, -s, s, 0.3],
        [1.0, 0.0, 0.0, 0.0],
        [0.0, s, s, 0.35],
        [0.0, 0.0, 0.0, 1.0],
    ]
)
scene.add(camera, pose=camera_pose)
light = pyrender.SpotLight(
    color=np.ones(3),
    intensity=3.0,
    innerConeAngle=np.pi / 16.0,
    outerConeAngle=np.pi / 6.0,
)
scene.add(light, pose=camera_pose)
color, depth = r.render(scene)


print(color.shape, color.dtype)
print(color.min(), color.max())

print(depth.shape, depth.dtype)
print(depth.min(), depth.max())

color = Image.fromarray(color.astype('uint8'), 'RGB')
color.save('color.png')


depth = Image.fromarray((depth * 2**7).astype('uint8'), 'L')
depth.save('depth.webp')

