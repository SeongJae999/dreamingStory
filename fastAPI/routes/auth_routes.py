# fastAPI/app/routes/auth_routes.py
from fastapi import APIRouter, Depends, HTTPException, status
from pydantic import BaseModel
from firebase_admin import auth as firebase_auth
from auth import get_current_user

router = APIRouter(
    prefix="/auth",
    tags=["auth"]
)

class SocialLoginRequest(BaseModel):
    id_token: str

@router.post("/social-login")
def social_login(request: SocialLoginRequest):
    try:
        decoded_token = firebase_auth.verify_id_token(request.id_token)
        uid = decoded_token['uid']
        email = decoded_token.get('email')
        # 추가적인 사용자 정보 처리 (예: DB 저장 등)
        return {"message": "Login successful", "uid": uid, "email": email}
    except Exception as e:
        raise HTTPException(status_code=400, detail="Invalid token")

@router.post("/password-reset")
def password_reset(email: str):
    try:
        firebase_auth.send_password_reset_email(email)
        return {"message": "Password reset email sent"}
    except Exception as e:
        raise HTTPException(status_code=400, detail=str(e))

@router.get("/current-user")
def get_user(uid: str = Depends(get_current_user)):
    try:
        user = firebase_auth.get_user(uid)
        return {"uid": user.uid, "email": user.email, "display_name": user.display_name, "photo_url": user.photo_url}
    except Exception as e:
        raise HTTPException(status_code=404, detail="User not found")
