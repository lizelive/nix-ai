#!/usr/bin/env python
from dataclasses import dataclass
from enum import Enum


class ModelKind(str, Enum):
    TEXT_TO_IMAGE = "diffusers.AutoPipelineForText2Image"


@dataclass
class FetchHuggingface:
    kind: ModelKind
    model: str
    varient: str = None


def fetch(fetch: FetchHuggingface, out: str):
    from transformers import AutoConfig, AutoModelForCausalLM, AutoTokenizer

    if fetch.kind == ModelKind.TEXT_TO_IMAGE:
        from diffusers import AutoPipelineForText2Image

        pipeline = AutoPipelineForText2Image.from_pretrained(
            fetch.model, variant=fetch.varient, use_safetensors=True
        )
        pipeline.save_pretrained(out)
    else:
        raise NotImplementedError(f"ModelKind {fetch.kind} not implemented")


if __name__ == "__main__":
    import argparse

    parser = argparse.ArgumentParser()
    parser.add_argument("--model", type=str, required=True)
    parser.add_argument("--variant", type=str, default=None)
    parser.add_argument("--out", type=str, required=True)
    parser.add_argument("--kind", type=str, required=True)
    args = parser.parse_args()

    fetch(
        FetchHuggingface(
            kind=ModelKind(args.kind), model=args.model, varient=args.variant
        ),
        args.out,
    )
