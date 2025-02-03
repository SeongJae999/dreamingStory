# fastAPI/app/models/story.py
from pydantic import BaseModel

class StartGenerationRequest(BaseModel):
    topic: str
    background: str
    character: str
    helper: str
    atmosphere: str
    
class StoryRequest(BaseModel):
    theme: str
    characters: str
    style: str

class StoryResponse(BaseModel):
    story_id: str
    story_text: str
    image_url: str
    audio_url: str
