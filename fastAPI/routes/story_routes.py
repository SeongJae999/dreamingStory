# fastAPI/app/routes/story_routes.py
from utils.story import generate_response
from utils.tts import synthesize_speech_to_file
from utils.auth import get_current_user
#from utils.image import generate_image
from utils.database import get_db
from utils.config import settings
from models.user import User

from fastapi import APIRouter, Depends, HTTPException
from fastapi.responses import JSONResponse
from firebase_admin import firestore
from pydantic import BaseModel
from pathlib import Path

import logging
import openai
import time

logger = logging.getLogger(__name__)

router = APIRouter(
    prefix="/stories",
    tags=["stories"]
)

db = get_db()
        
openai.api_key = ""

class ChatRequest(BaseModel):
    topic: str

class Feedback(BaseModel):
    rating: float
    error: str | None = None
    timestamp: str = None

async def save_feedback_to_firestore(feedback: dict):
    try:
        db.collection("feedbacks").add(feedback)
        return {"message": "Feedback submitted successfully"}
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Firestore error: {str(e)}")

async def generate_image_prompt(user_prompt: str) -> str:
    try:
        client = openai.OpenAI(api_key=settings.OPENAI_API_KEY)
        
        with open('/prompts/imgGen_prompt.txt', 'r', encoding='utf-8') as file:
            system_prompt = file.read()
        response = client.chat.completions.create(
            model="gpt-4o",
            messages=[
                {"role": "system", "content": system_prompt},
                {"role": "user", "content": user_prompt}
            ],
            temperature=0.2,
            max_tokens=70
        )
        image_prompt = response.choices[0].message.content
        
        return image_prompt
    except Exception as e:
        print(f"GPT API 호출 중 오류 발생: {e}")
        raise e
    
@router.post("/generate_story")
async def generate_story(request: ChatRequest, current_user: User = Depends(get_current_user)):
    try:
        response = generate_response(request.topic)
        logger.info(f"동화 생성: {response}")
        
        parts = response.split('---')
        if len(parts) < 6:
            raise ValueError("Unexpected reponse format.")
        
        title=parts[0]
        first=parts[1]
        second=parts[2]
        third=parts[3]
        forth=parts[4]
        wisdom=parts[5]
        
        only_title = title.split("\n")[1]
        base_dir = Path("output")
        save_dir = base_dir / current_user.uid / only_title
        
        user_image_dir = save_dir / "images"
        user_image_dir.mkdir(parents=True, exist_ok=True)
        
        image_urls = {}
        story_parts = {"first": first}
        for key, part in story_parts.items():
           # prompt = await generate_image_prompt(part)
           # file_name = generate_image(output_filename=user_image_dir, prompt=prompt)
            image_urls[key] = f"output/{current_user.uid}/{only_title}/images/wow.png"
        
        user_audio_dir = save_dir / "audios"
        user_audio_dir.mkdir(parents=True, exist_ok=True)
        
        logger.info("TTS 변환중...")
        texts = {
            "title": title,
            "first": first,
            "second": second,
            "third": third,
            "forth": forth,
            "wisdom": wisdom
        }
        audio_urls = {}
        for key, text in texts.items():
            timestamp = int(time.time() * 1000)
            filename = f"{key}_narration_{timestamp}.mp3"
            output_filepath = user_audio_dir / filename

            synthesize_speech_to_file(text, output_filename=str(output_filepath))
            logger.info(f"{key} 부분 TTS 변환 완료: {filename}로 저장됨")

            audio_urls[key] = f"output/{current_user.uid}/{only_title}/audios/{filename}"
        
        logger.info(f"TTS 변환 완료")

        response_data = {
            "title": title, 
            "story": {
                "first": first, 
                "second": second, 
                "third": third, 
                "forth": forth
            }, 
            "wisdom": wisdom, 
            "audio_urls": audio_urls,
            "image_urls": image_urls
        }
        
        db.collection("story").add({
            "title": title,
            "story": {
                "first": first,
                "second": second,
                "third": third,
                "forth": forth
            },
            "wisdom": wisdom,
            "audio_urls": audio_urls,
            "image_urls": image_urls,
            "user_id": current_user.uid,  
            "created_at": firestore.SERVER_TIMESTAMP 
        })
        
        logger.info(f"동화 데이터 Firestore에 저장 완료")
        
        logger.info("생성된 동화와 내레이션을 JSON으로 전달.")
        return JSONResponse(content=response_data, media_type="application/json; charset=utf-8")
    
    except ValueError as ve:
        logger.error(f"ValueError occurred: {ve}")
        raise HTTPException(status_code=400, detail=str(ve))
    
    except Exception as e:
        logger.error(f"Error occurred: {e}")
        raise HTTPException(status_code=500, detail="서버에서 오류가 발생했습니다.")

@router.post('/free_story')
async def free_story(request: dict):
    story_id = request.get('story_id')
    
    try:
        doc_ref = db.collection("story").document(story_id) 
        doc = doc_ref.get()

        if doc.exists:
            story_data = doc.to_dict()
            return story_data 
        else:
            raise HTTPException(status_code=404, detail="Story not found")
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error fetching story: {str(e)}")

@router.post("/submit-feedback")
async def submit_feedback(feedback: Feedback, current_user: User = Depends(get_current_user)):
    feedback_dict = {
        "rating": feedback.rating,
        "error": feedback.error,
        "timestamp": feedback.timestamp if feedback.timestamp else firestore.SERVER_TIMESTAMP,
        'user_id' : current_user.uid,
    }

    try:
        result = await save_feedback_to_firestore(feedback_dict)
        return {"message": "Feedback submitted successfully", "result": result}
    except HTTPException as e:
        raise e