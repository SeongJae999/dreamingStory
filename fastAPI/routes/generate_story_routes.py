from fastapi import APIRouter, HTTPException, BackgroundTasks, Depends
from utils.tts import synthesize_speech_to_file
from utils.auth import get_current_user
from utils.config import settings
from utils.database import get_db
from utils.image import generate_image
from utils.story import generate_response
from models.user import User
from models.story import StartGenerationRequest

from firebase_admin import firestore
from pathlib import Path
from pydantic import BaseModel
from typing import Optional

from openai import OpenAI

client = OpenAI(api_key=settings.OPENAI_API_KEY)
import time
import re

router = APIRouter(
    prefix="/generate_stories",
    tags=["generate_stories"]
)

class PartContent(BaseModel):
    text: str
    image_url: Optional[str] = None
    audio_url: Optional[str] = None

class FetchPartResponse(BaseModel):
    part: str
    content: PartContent

db = get_db()

def generate_image_prompt(user_prompt: str) -> str:
    try:
        with open('/home/jeonlaejohgun/fastAPI/prompts/imgGen_prompt_v3.txt', 'r', encoding='utf-8') as file:
            system_prompt = file.read()
        if not isinstance(user_prompt, str):
            import json
            user_prompt = json.dumps(user_prompt, ensure_ascii=False)
            
        response = client.chat.completions.create(
            model="gpt-4o",
            messages=[
                {"role": "system", "content": system_prompt},
                {"role": "user", "content": user_prompt}
            ],
            temperature=0.2,
            max_tokens=70
        )
        image_prompt = response.choices[0].message.content.strip()

        return image_prompt
    except Exception as e:
        print(f"GPT API 호출 중 오류 발생: {e}")
        raise e

def split_story_into_parts(story_text: str) -> dict:
    try:
        sections = story_text.split('---')
        if len(sections) < 2:
            raise ValueError("텍스트 형식이 올바르지 않습니다. '---' 구분자가 필요합니다.")

        title_section = sections[0].strip()
        title = re.sub(r'^\[.*?\]', '', title_section).strip()
        if not title:
            raise ValueError("제목이 비어 있습니다.")

        split_parts = {}
        for section in sections[1:]:
            section = section.strip()
            if not section:
                continue
 
            part_match = re.match(r'\[(.*?)\]', section)
            if part_match:
                part_name = part_match.group(1).strip()
                part_content = re.sub(r'^\[.*?\]', '', section).strip()
                split_parts[part_name] = part_content
            else:
                print(f"Unknown section format: {section}")

        mapped_parts = {}
        for part_name, part_text in split_parts.items():
            if part_name == "도입부 내용":
                mapped_parts["first"] = {"text": part_text, "image_url": None, "audio_url": None}
            elif part_name == "전개부 내용":
                mapped_parts["second"] = {"text": part_text, "image_url": None, "audio_url": None}
            elif part_name == "절정부 내용":
                mapped_parts["third"] = {"text": part_text, "image_url": None, "audio_url": None}
            elif part_name == "결말부 내용":
                mapped_parts["forth"] = {"text": part_text, "image_url": None, "audio_url": None}
            elif part_name == "이 이야기를 통해 아이와 같이 나눠보면 좋을 내용":
                mapped_parts["wisdom"] = {"text": part_text, "image_url": None, "audio_url": None}
            else:
                print(f"Unknown part name: {part_name}")
                pass

        mapped_parts["title"] = {"text": title, "image_url": None, "audio_url": None}
        
        print(f"Mapped parts: {mapped_parts.keys()}")

        return mapped_parts
    except Exception as e:
        print(f"스토리 텍스트 분할 중 오류 발생: {e}")
        raise e



@router.post("/start_generation")
async def start_story_generation(request: StartGenerationRequest, current_user: User = Depends(get_current_user)):
    task_id = f"story_{int(time.time())}"

    story_text = generate_response(request)
    try:
        split_parts = split_story_into_parts(story_text)
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"텍스트 분할 실패: {str(e)}")

    db.collection("tasks").document(task_id).set({
        "status": "started",
        "topic": request.topic,
        "user_id": current_user.uid,
        "parts": split_parts,
        "created_at": firestore.SERVER_TIMESTAMP,
    })
    
    print(f"Task '{task_id}' created with parts: {split_parts.keys()}")

    return {"task_id": task_id, "status": "started"}

@router.get("/fetch_part/{task_id}/{part}", response_model=FetchPartResponse)
async def fetch_part(task_id: str, part: str, current_user: User = Depends(get_current_user)):
    task_ref = db.collection("tasks").document(task_id)
    task = task_ref.get().to_dict()

    if not task or task.get("user_id") != current_user.uid:
        raise HTTPException(status_code=404, detail="작업을 찾을 수 없습니다.")

    part_content = task.get("parts", {}).get(part)
    if not part_content:
        raise HTTPException(status_code=404, detail=f"{part} 파트가 아직 생성되지 않았습니다.")

    response = FetchPartResponse(
        part=part,
        content=PartContent(
            text=part_content.get("text", ""),
            image_url=part_content.get("image_url"),
            audio_url=part_content.get("audio_url")
        )
    )

    return response

@router.post("/generate_part/{task_id}/{part}")
async def trigger_generate_part(
    task_id: str, 
    part: str, 
    background_tasks: BackgroundTasks, 
    current_user: User = Depends(get_current_user)
):
    task_ref = db.collection("tasks").document(task_id)
    task = task_ref.get().to_dict()

    if not task or task["user_id"] != current_user.uid:
        raise HTTPException(status_code=404, detail="작업을 찾을 수 없습니다.")

    part_text = task.get("parts", {}).get(part)
    if not part_text:
        raise HTTPException(status_code=400, detail=f"{part} 파트의 텍스트가 없습니다.")

    def generate_part_in_background():
        try:
            base_dir = Path("/home/jeonlaejohgun/fastAPI")
            task_dir = Path("output") / current_user.uid / task_id
            image_dir = base_dir / task_dir / "images"
            audio_dir = base_dir / task_dir / "audios"

            image_dir.mkdir(parents=True, exist_ok=True)
            audio_dir.mkdir(parents=True, exist_ok=True)

            image_prompt = generate_image_prompt(part_text)
            image_filename = generate_image(output_filename=image_dir, prompt=image_prompt)
            image_url = str(task_dir / "images" / image_filename)
            
            audio_filename = f"{part}_{int(time.time())}.mp3"
            audio_path = audio_dir / audio_filename
            part_data = task.get("parts", {}).get(part)
            actual_text = part_data.get("text", "")
            synthesize_speech_to_file(actual_text, output_filename=str(audio_path))
            audio_url = str(task_dir / "audios" / audio_filename)

            task_ref.update({
                f"parts.{part}": {
                    "text": actual_text,
                    "image_url": image_url,
                    "audio_url": audio_url,
                },
                "status": "in_progress",
            })
        except Exception as e:
            task_ref.update({
                "status": "error",
                "error_message": str(e),
            })

    background_tasks.add_task(generate_part_in_background)
    return {"status": f"Generating {part} in the background"}

@router.get("/check_status/{task_id}")
def check_status(task_id: str, current_user: User = Depends(get_current_user)):
    task_ref = db.collection("tasks").document(task_id)
    task = task_ref.get().to_dict()

    if not task or task.get("user_id") != current_user.uid:
        raise HTTPException(status_code=404, detail="작업을 찾을 수 없습니다.")

    return {
        "status": task["status"],
        "parts": task.get("parts", {})
    }