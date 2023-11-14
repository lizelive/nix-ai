import importlib
import os
import json


def parse_torch_dtype(dtype: str):
    import torch

    torch_dtype = getattr(torch, dtype, None)
    if not isinstance(torch_dtype, torch.dtype):
        return torch_dtype
    raise ValueError(f"unknown dtype {dtype}")


def fetch(download: dict, out: str):
    "fetch a model from huggingface"

    model_id = download.pop("model_id")

    kind = download.pop("kind")
    module_name, class_name = kind.rsplit(".", maxsplit=1)
    cls_module = importlib.import_module(module_name)
    cls = getattr(cls_module, class_name)

    match download.pop("dtype", None):
        case None:
            pass
        case "auto":
            download["torch_dtype"] = "auto"
        case dtype:
            download["torch_dtype"] = parse_torch_dtype(dtype)

    model = cls.from_pretrained(model_id, **download)

    model.save_pretrained(out)
    return model


args = json.loads(os.environ["fetch"])
out = os.environ["out"]

fetch(download=args, out=out)
