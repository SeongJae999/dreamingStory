# fastAPI/app/services/comfyui_service.py
import httpx
from utils.config import settings

async def generate_image(text: str) -> str:
    payload = {"text": text}
    async with httpx.AsyncClient() as client:
        response = await client.post(settings.COMFYUI_API_URL, json=payload)
    response.raise_for_status()
    image_url = response.json().get("image_url")
    return image_url
