# fastAPI/app/services/tts_service.py
import httpx
from utils.config import settings

async def convert_text_to_speech(text: str) -> str:
    payload = {"text": text}
    async with httpx.AsyncClient() as client:
        response = await client.post(settings.TTS_API_URL, json=payload)
    response.raise_for_status()
    audio_url = response.json().get("audio_url")
    return audio_url
