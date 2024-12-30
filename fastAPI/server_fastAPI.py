from fastapi import FastAPI
import requests

app = FastAPI()

@app.post("/generate-story/")
async def generate_story(theme: str, characters: str):
    response = requests.post(
        "https://api.openai.com/v1/completions",
        headers={"Authorization": f"Bearer YOUR_API_KEY"},
        json={
            "model": "text-davinci-003",
            "prompt": f"Write a story about {theme} with characters: {characters}",
            "max_tokens": 500,
            "temperature": 0.7,
        },
    )
    return {"story": response.json().get("choices")[0]["text"]}
