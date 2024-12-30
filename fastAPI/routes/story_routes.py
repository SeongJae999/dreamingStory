# fastAPI/app/routes/story_routes.py
from fastapi import APIRouter, Depends, HTTPException
from pydantic import BaseModel
from firebase_admin import firestore

from models.story import StoryRequest, StoryResponse
from auth import get_current_user
from services.gpt_service import generate_story
from services.comfyui_service import generate_image
from services.tts_service import convert_text_to_speech
from utils.database import get_db

router = APIRouter(
    prefix="/stories",
    tags=["stories"]
)

@router.post("/create", response_model=StoryResponse)
async def create_story(request: StoryRequest, user_id: str = Depends(get_current_user)):
    db = get_db()
    try:
        # GPT API 호출
        story_text = await generate_story(request.theme, request.characters, request.style)

        # ComfyUI 이미지 생성
        image_url = await generate_image(story_text)

        # TTS 변환
        audio_url = await convert_text_to_speech(story_text)

        # Firestore에 스토리 저장
        story_data = {
            "theme": request.theme,
            "characters": request.characters,
            "style": request.style,
            "story_text": story_text,
            "image_url": image_url,
            "audio_url": audio_url,
            "user_id": user_id
        }
        doc_ref = db.collection("stories").add(story_data)
        story_id = doc_ref[1].id

        return StoryResponse(
            story_id=story_id,
            story_text=story_text,
            image_url=image_url,
            audio_url=audio_url
        )
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@router.get("/{story_id}", response_model=StoryResponse)
def get_story(story_id: str, user_id: str = Depends(get_current_user)):
    db = get_db()
    try:
        doc = db.collection("stories").document(story_id).get()
        if not doc.exists:
            raise HTTPException(status_code=404, detail="Story not found")
        story_data = doc.to_dict()
        if story_data["user_id"] != user_id:
            raise HTTPException(status_code=403, detail="Not authorized to view this story")
        return StoryResponse(
            story_id=story_id,
            story_text=story_data["story_text"],
            image_url=story_data["image_url"],
            audio_url=story_data["audio_url"]
        )
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
