# fastAPI/routes/auth_routes.py
from utils.auth import get_current_user
from models.user import User

from fastapi import APIRouter, Depends, HTTPException
from pydantic import BaseModel
from firebase_admin import auth as firebase_auth

import logging

router = APIRouter(
    prefix="/auth",
    tags=["Auth"]
)

class SocialLoginRequest(BaseModel):
    id_token: str

@router.post("/social-login")
def social_login(request: SocialLoginRequest):
    try:
        decoded_token = firebase_auth.verify_id_token(request.id_token)
        uid = decoded_token['uid']
        email = decoded_token.get('email')
        logging.info(f"Social login successful. UID: {uid}, Email: {email}")
        # 추가적인 사용자 정보 처리 (예: DB 저장 등)
        return {"message": "Login successful", "uid": uid, "email": email}
    except firebase_admin.auth.InvalidIdTokenError:
        logging.error("Invalid ID token.")
        raise HTTPException(status_code=400, detail="Invalid token")
    except Exception as e:
        logging.error(f"Social login failed: {e}")
        raise HTTPException(status_code=400, detail="Invalid token")

@router.post("/password-reset")
def password_reset(request: dict):
    email = request.get("email")
    if not email:
        raise HTTPException(status_code=400, detail="Email is required")
    try:
        firebase_auth.send_password_reset_email(email)
        logging.info(f"Password reset email sent to {email}")
        return {"message": "Password reset email sent"}
    except Exception as e:
        logging.error(f"Password reset failed: {e}")
        raise HTTPException(status_code=400, detail=str(e))

@router.get("/current-user", response_model=User)
def get_user(user: User = Depends(get_current_user)):
    return user