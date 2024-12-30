# fastAPI/app/services/gpt_service.py
import httpx
from utils.config import settings

async def generate_story(theme: str, characters: str, style: str) -> str:
    prompt = f"Create a story with theme {theme}, characters {characters}, and style {style}"
    headers = {
        "Authorization": f"Bearer {settings.OPENAI_API_KEY}",
        "Content-Type": "application/json"
    }
    data = {
        "prompt": prompt,
        "max_tokens": 500,
        "temperature": 0.7,
        "n": 1,
        "stop": None
    }
    async with httpx.AsyncClient() as client:
        response = await client.post(
            "https://api.openai.com/v1/engines/davinci/completions",
            json=data,
            headers=headers
        )
    response.raise_for_status()
    gpt_text = response.json()["choices"][0]["text"].strip()
    return gpt_text
