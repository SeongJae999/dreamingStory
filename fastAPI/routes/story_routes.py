# fastAPI/app/routes/story_routes.py
from utils.auth import get_current_user
from utils.database import get_db
from models.user import User

from fastapi import APIRouter, Depends, HTTPException
from firebase_admin import firestore
from pydantic import BaseModel

import logging

logger = logging.getLogger(__name__)

router = APIRouter(
    prefix="/stories",
    tags=["stories"]
)

db = get_db()

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

@router.get("/recent_stories")
async def get_recent_stories(current_user: User = Depends(get_current_user)):
    try:
        stories_ref = db.collection('tasks')
        docs = (
            stories_ref
            .where(field_path='user_id', op_string='==', value=current_user.uid)
            .order_by('created_at', direction=firestore.Query.DESCENDING)
            .limit(8)
            .stream()
        )
        
        stories = []
        for doc in docs:
            doc_data = doc.to_dict() 
            doc_data["doc_id"] = doc.id 
            stories.append(doc_data)
            
        return {"stories": stories}
    
    except Exception as e:
        print(f"Error in get_recent_stories: {e}")
        raise HTTPException(status_code=500, detail=str(e))

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