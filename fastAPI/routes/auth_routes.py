# app/routes/auth_routes.py
from fastapi import APIRouter, Depends, HTTPException, status
from pydantic import BaseModel
from firebase_admin import auth
from auth import get_current_user

router = APIRouter()

class SocialLoginRequest(BaseModel):
    id_token: str

@router.post("/social-login")
def social_login(request: SocialLoginRequest):
    try:
        decoded_token = auth.verify_id_token(request.id_token)
        uid = decoded_token['uid']
        return {"message": "Login successful", "uid": uid}
    except Exception as e:
        raise HTTPException(status_code=400, detail="Invalid token")

