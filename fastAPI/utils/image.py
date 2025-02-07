import torch
import random
import sys
import os

LOADED_MODELS = {
    "dualcliploader": None,
    "vaeloader": None,
    "unetloader": None,
    "loraloader": None
}

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

def load_image_models():
    """
    모델들이 로드되어 있지 않다면 로드하고, 이미 로드되어 있다면 스킵합니다.
    """
    global LOADED_MODELS

    if LOADED_MODELS["dualcliploader"] is None:
        dualclip = DualCLIPLoader()
        loaded_clip = dualclip.load_clip(
            clip_name1="t5xxl_fp16.safetensors",
            clip_name2="clip_l.safetensors",
            type="flux",
            device="default",
        )
        LOADED_MODELS["dualcliploader"] = loaded_clip
        print("dualclip 로드 완료")
    
    if LOADED_MODELS["vaeloader"] is None:
        vae_loader = VAELoader()
        loaded_vae = vae_loader.load_vae(vae_name="flux-vae-bf16.safetensors")
        LOADED_MODELS["vaeloader"] = loaded_vae
        print("vae 로드 완료")
        
    if LOADED_MODELS["unetloader"] is None:
        unet_loader = UNETLoader()
        loaded_unet = unet_loader.load_unet(
            unet_name="flux1-schnell-fp8-e4m3fn.safetensors", 
            weight_dtype="default"
        )
        LOADED_MODELS["unetloader"] = loaded_unet
        print("unet 로드 완료")
        
    if LOADED_MODELS["loraloader"] is None:
        lora_loader = LoraLoader()

        loaded_lora = lora_loader.load_lora(
            lora_name="j_3dgame_flux.safetensors",
            strength_model=1,
            strength_clip=1,
            model=get_value_at_index(LOADED_MODELS["unetloader"], 0),
            clip=get_value_at_index(LOADED_MODELS["dualcliploader"], 0),
        )
        LOADED_MODELS["loraloader"] = loaded_lora
        print("lora 로드 완료")
        
def generate_image(output_filename: str = "output.jpg", prompt: str = ""):

    load_image_models()
        
    with torch.inference_mode():
        emptylatentimage = EmptyLatentImage()
        cliptextencode = CLIPTextEncode()
        ksampler = KSampler()
        vaedecode = VAEDecode()
        saveimage = SaveImage()

        emptylatentimage_5 = emptylatentimage.generate(
            width=1280, height=800, batch_size=1
        )

        dualcliploader_11 = LOADED_MODELS["dualcliploader"]

        cliptextencode_6 = cliptextencode.encode(
            text=prompt,
            clip=get_value_at_index(dualcliploader_11, 0),
        )

        vaeloader_10 = LOADED_MODELS["vaeloader"]
        loraloader_49 = LOADED_MODELS["loraloader"]

        cliptextencode_35 = cliptextencode.encode(
            text="text, blurry, shiny, photo, soft, nsfw, nude, ugly, broken, watermark, oversaturated,  extra digit, fewer digits, missing fingers, strange fingers, fewer fingers, missing arms, bad feet, bad legs, deformed, extra limbs",
            clip=get_value_at_index(loraloader_49, 1),
        )

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
            filename_prefix=str(output_filename), 
            images=get_value_at_index(vaedecode_29, 0)
        )

        return saveimage_30["ui"]["images"][0]["filename"]