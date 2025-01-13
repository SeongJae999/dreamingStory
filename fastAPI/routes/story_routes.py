# fastAPI/app/routes/story_routes.py
from utils.story import generate_response
from utils.tts import synthesize_speech_to_file
from utils.auth import get_current_user
from models.user import User

from fastapi import APIRouter, Depends, HTTPException
from fastapi.responses import JSONResponse
from pydantic import BaseModel
from pathlib import Path

import logging
import time

logger = logging.getLogger(__name__)

router = APIRouter(
    prefix="/stories",
    tags=["stories"]
)

class ChatRequest(BaseModel):
    topic: str

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
        
        base_dir = Path("output")
        user_audio_dir = base_dir / current_user.uid / "audios"
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

            audio_urls[key] = f"output/{current_user.uid}/audios/{filename}"
            
        logger.info(f"TTS 변환 완료")
        
        response_data = {"title": title, 
                         "story": {
                             "first": first, 
                             "second": second, 
                             "third": third, 
                             "forth": forth
                             }, 
                         "wisdom": wisdom, 
                         "audio_urls": audio_urls
                         }
        logger.info("생성된 동화와 내레이션을 JSON으로 전달.")
        return JSONResponse(content=response_data, media_type="application/json; charset=utf-8")
    
    except ValueError as ve:
        logger.error(f"ValueError occurred: {ve}")
        raise HTTPException(status_code=400, detail=str(ve))
    
    except Exception as e:
        logger.error(f"Error occurred: {e}")
        raise HTTPException(status_code=500, detail="서버에서 오류가 발생했습니다.")
