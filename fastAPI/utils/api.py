from datetime import datetime
from dotenv import load_dotenv

import os
import requests

load_dotenv()

openai_api_key = os.getenv("OPENAI_API_KEY")
# anthropic_api_key = os.getenv("ANTHROPIC_API_KEY")
stability_api_key = os.getenv("STABILITY_API_KEY")

def sd_generate_image_v2(prompt, 
                        negative_prompt="",
                        size=(512, 512), 
                        steps=20,
                        seed=2025):
    # https://platform.stability.ai/docs/api-reference#tag/SDXL-1.0-and-SD1.6/operation/textToImage
    save_path = "../output/images"

    width, height = size

    negative_prompt = "watermark, text, blurry, dark, " + negative_prompt

    response = requests.post(
        # version 2
        f"https://api.stability.ai/v2beta/stable-image/generate/core",

        # version 1
        #f"https://api.stability.ai/v1/generation/stable-diffusion-v1-6/text-to-image",
        headers={
            "authorization": f"Bearer {stability_api_key}",
            "accept": "image/*"
        },
        files={"none": ''},
        data={
            "prompt": prompt,
            "negative_prompt": negative_prompt,
            "output_format": "png",
            "seed": seed,
            "width": width,
            "height": height,
            "steps": steps,
        },
    )

    if response.status_code == 200:
        file_name = datetime.now().strftime("%Y%m%d_%H%M%S")
        image_path = f"{save_path}/{file_name}.png"
        with open(f"{save_path}/{file_name}.png", 'wb') as file:
            file.write(response.content)
        return image_path
    else:
        raise Exception(str(response.json()))



def gpt_generate_text(prompt, temperature=0.7, model='gpt-4o-mini'):

    url = "https://api.openai.com/v1/chat/completions"
    headers = {
        "Content-Type": "application/json",
        "Authorization": f"Bearer {openai_api_key}"
    }

    payload = {
        "model": model,
        "messages": [{"role": "user", "content": prompt}],
        "temperature": temperature
    }

    response = requests.post(url, headers=headers, json=payload)

    if response.status_code == 200:
        return response.json()["choices"][0]["message"]["content"] 
    else:
        print(f"Error: {response.status_code}, {response.text}")  
        return None
    


def sd_generate_image_v1(prompt,
                         negative_prompt='', 
                        size=(512, 512), 
                        steps=20,
                        seed=2025):
    # https://platform.stability.ai/docs/api-reference#tag/SDXL-1.0-and-SD1.6
    engine_id = "stable-diffusion-v1-6"
    width, height = size
    save_path = "../output/images"
    negative_prompt = "watermark, text, blurry, dark, " + negative_prompt

    response = requests.post(
        f"https://api.stability.ai/v1/generation/{engine_id}/text-to-image",
        headers={
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Authorization": f"Bearer {stability_api_key}"
        },
        json={
                "text_prompts": [
                {
                    "text": prompt,
                    "weight": 1
                },
                 {
                    "text": negative_prompt,
                    "weight": -1
                }],
            "cfg_scale": 7,
            "height": height,
            "width": width,
            "samples": 1,
            "steps": steps,
            "seed": seed
        },
    )

    if response.status_code == 200:
        file_name = datetime.now().strftime("%Y%m%d_%H%M%S")
        image_path = f"{save_path}/{file_name}.png"
        with open(f"{save_path}/{file_name}.png", 'wb') as file:
            file.write(response.content)
        return image_path
    else:
        raise Exception(str(response.json()))