import torch
import random
import sys
import os

def get_value_at_index(obj, index: int):
    try:
        return obj[index]
    except KeyError:
        return obj["result"][index]


def find_path(name: str, path: str = None) -> str:
    if path is None:
        path = os.getcwd()
    if name in os.listdir(path):
        path_name = os.path.join(path, name)
        return path_name
    parent_directory = os.path.dirname(path)
    if parent_directory == path:
        return None
    return find_path(name, parent_directory)

def add_comfyui_directory_to_sys_path() -> None:
    comfyui_path = find_path("ComfyUI")
    if comfyui_path is not None and os.path.isdir(comfyui_path):
        sys.path.append(comfyui_path)

def add_extra_model_paths() -> None:
    try:
        from ComfyUI.main import load_extra_path_config
    except ImportError:
        from ComfyUI.utils.extra_config import load_extra_path_config
    extra_model_paths = find_path("extra_model_paths.yaml")
    if extra_model_paths is not None:
        load_extra_path_config(extra_model_paths)
        
add_comfyui_directory_to_sys_path()
add_extra_model_paths()

from ComfyUI.nodes import (
    SaveImage, CLIPTextEncode, KSampler, VAEDecode, EmptyLatentImage,
    CheckpointLoaderSimple, LoraLoader
)

def generate_image(output_filename: str = "output.jpg", prompt: str = ""):
    with torch.inference_mode():
        checkpointloadersimple = CheckpointLoaderSimple()
        checkpointloadersimple_4 = checkpointloadersimple.load_checkpoint(
            ckpt_name="flux1-dev-fp8.safetensors"
        )

        emptylatentimage = EmptyLatentImage()
        emptylatentimage_5 = emptylatentimage.generate(width=1024, height=1024, batch_size=1)

        loraloader = LoraLoader()
        loraloader_11 = loraloader.load_lora(
            lora_name="j_3dgame_flux.safetensors",
            strength_model=0.9,
            strength_clip=1,
            model=get_value_at_index(checkpointloadersimple_4, 0),
            clip=get_value_at_index(checkpointloadersimple_4, 1),
        )

        cliptextencode = CLIPTextEncode()
        cliptextencode_6 = cliptextencode.encode(
            text=prompt,
            clip=get_value_at_index(loraloader_11, 1),
        )

        cliptextencode_12 = cliptextencode.encode(
            text="text, wartermark", clip=get_value_at_index(loraloader_11, 1)
        )
        
        ksampler = KSampler()
        vaedecode = VAEDecode()
        saveimage = SaveImage()

        ksampler_3 = ksampler.sample(
            seed=random.randint(1, 2**64),
            steps=25,
            cfg=1.5,
            sampler_name="lms",
            scheduler="simple",
            denoise=1,
            model=get_value_at_index(loraloader_11, 0),
            positive=get_value_at_index(cliptextencode_6, 0),
            negative=get_value_at_index(cliptextencode_12, 0), 
            latent_image=get_value_at_index(emptylatentimage_5, 0),
        )

        vaedecode_8 = vaedecode.decode(
            samples=get_value_at_index(ksampler_3, 0),
            vae=get_value_at_index(checkpointloadersimple_4, 2),
        )
        
        saveimage_9 = saveimage.save_images(
            filename_prefix=str(output_filename), images=get_value_at_index(vaedecode_8, 0)
        )
        
        return saveimage_9["ui"]["images"][0]["filename"]