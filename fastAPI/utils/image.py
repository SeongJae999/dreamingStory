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
    SaveImage, 
    CLIPTextEncode, 
    KSampler, 
    VAELoader,
    VAEDecode,
    EmptyLatentImage, 
    DualCLIPLoader,
    NODE_CLASS_MAPPINGS,
    UNETLoader,
    LoraLoader
)

def generate_image(output_filename: str = "output.jpg", prompt: str = ""):
    with torch.inference_mode():
        emptylatentimage = EmptyLatentImage()
        emptylatentimage_5 = emptylatentimage.generate(
            width=1280, height=800, batch_size=1
        )

        dualcliploader = DualCLIPLoader()
        dualcliploader_11 = dualcliploader.load_clip(
            clip_name1="t5xxl_fp16.safetensors",
            clip_name2="clip_l.safetensors",
            type="flux",
            device="default",
        )

        cliptextencode = CLIPTextEncode()
        cliptextencode_6 = cliptextencode.encode(
            text="'title': 'Baridegi',\n  'introduction': \n    'description': 'In a grand palace, the king looks disappointed as the queen cradles their newborn daughter, Baridegi, while a nursemaid stands nearby, looking concerned.',\n    'leading_role': 'Baridegi, a newborn girl with a gentle, glowing aura, and the king, a stern figure dressed in regal robes, with the queen looking tenderly at the baby.',\n    'subject': 'The king’s disappointment at Baridegi’s birth.',\n    'style': 'Traditional and regal, inspired by Korean folk art with rich textures and intricate details.',\n    'composition': 'The king is seated on the throne in the background, while the queen holds Baridegi in the foreground, creating a stark contrast between joy and disappointment.',\n    'lighting': 'Soft, golden light illuminates the queen and Baridegi, while the king sits in shadow, symbolizing his displeasure.',\n    'color_palette': 'Deep reds and golds for the palace, with soft whites and pinks for the queen and Baridegi.',\n    'mood_atmosphere': 'Bittersweet and dramatic, highlighting the emotional tension.',\n    'technical_details': 'Medium perspective focusing on the interplay of light and shadow between the king and the queen.',\n    'additional_elements': 'Intricate palace decorations, including embroidered curtains and a gleaming golden throne.'\n  ",
            clip=get_value_at_index(dualcliploader_11, 0),
        )

        vaeloader = VAELoader()
        vaeloader_10 = vaeloader.load_vae(vae_name="flux-vae-bf16.safetensors")

        unetloader = UNETLoader()
        unetloader_12 = unetloader.load_unet(
            unet_name="flux1-schnell-fp8-e4m3fn.safetensors", weight_dtype="default"
        )

        loraloader = LoraLoader()
        loraloader_49 = loraloader.load_lora(
            lora_name="j_3dgame_flux.safetensors",
            strength_model=1,
            strength_clip=1,
            model=get_value_at_index(unetloader_12, 0),
            clip=get_value_at_index(dualcliploader_11, 0),
        )

        cliptextencode_35 = cliptextencode.encode(
            text="text, blurry, shiny, photo, soft, nsfw, nude, ugly, broken, watermark, oversaturated,  extra digit, fewer digits, missing fingers, strange fingers, fewer fingers, missing arms, bad feet, bad legs, deformed, extra limbs",
            clip=get_value_at_index(loraloader_49, 1),
        )

        ksampler = KSampler()
        vaedecode = VAEDecode()
        saveimage = SaveImage()

        ksampler_32 = ksampler.sample(
            seed=random.randint(1, 2**64),
            steps=10,
            cfg=1,
            sampler_name="euler",
            scheduler="simple",
            denoise=1,
            model=get_value_at_index(loraloader_49, 0),
            positive=get_value_at_index(cliptextencode_6, 0),
            negative=get_value_at_index(cliptextencode_35, 0),
            latent_image=get_value_at_index(emptylatentimage_5, 0),
        )

        vaedecode_29 = vaedecode.decode(
            samples=get_value_at_index(ksampler_32, 0),
            vae=get_value_at_index(vaeloader_10, 0),
        )
        
        saveimage_30 = saveimage.save_images(
            filename_prefix=str(output_filename), images=get_value_at_index(vaedecode_29, 0)
        )    
        
        return saveimage_30["ui"]["images"][0]["filename"]