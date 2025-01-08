# fastAPI/routes/auth_routes.py
from fastapi import APIRouter, Depends, HTTPException
from pydantic import BaseModel
from firebase_admin import auth as firebase_auth
from auth import get_current_user
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

@router.get("/current-user")
def get_user(uid: str = Depends(get_current_user)):
    try:
        user = firebase_auth.get_user(uid)
        logging.info(f"User found: UID: {user.uid}, Email: {user.email}")
        return {
            "uid": user.uid,
            "email": user.email,
            "display_name": user.display_name,
        }
    except firebase_admin.auth.UserNotFoundError:
        logging.error(f"User not found: UID: {uid}")
        raise HTTPException(status_code=404, detail="User not found")
    except Exception as e:
        logging.error(f"Error retrieving user: {e}")
        raise HTTPException(status_code=500, detail="Internal server error")

from fastapi import File, UploadFile, HTTPException
import base64
from utils.database import get_db
from fastapi.responses import HTMLResponse

@router.post("/upload/")
async def upload_image(file: UploadFile = File(...)):
    # 이미지 파일을 Base64로 인코딩
    image_data = await file.read()
    encoded_image = base64.b64encode(image_data).decode('utf-8')
    
    db = get_db()

    # Firestore 문서에 이미지 필드로 저장
    doc_ref = db.collection('story').document('flower')
    doc_ref.set({
        'image': encoded_image
    }, merge=True)  # 기존의 다른 필드를 유지하면서 'image' 필드만 추가하거나 업데이트

    return {"message": "Image uploaded successfully"}

@router.get("/get-image/{document_name}", response_class=HTMLResponse)
async def get_image(document_name: str):
    try:
        db = get_db()
        # Firestore에서 이미지 데이터 가져오기
        doc_ref = db.collection('story').document(document_name)
        doc = doc_ref.get()
        if not doc.exists:
            raise HTTPException(status_code=404, detail="Document not found")
        encoded_image = doc.to_dict().get('image')
        
        # HTML 페이지로 이미지 데이터를 디코드하여 표시
        html_content = f'<img src="data:image/jpeg;base64,{encoded_image}"/>'
        return html_content
    except Exception as e:
        print(f"Failed to retrieve image: {e}")
        raise HTTPException(status_code=500, detail="Failed to retrieve image")