# fastAPI/routes/auth_routes.py
from utils.auth import get_current_user
from utils.database import get_db
from models.user import User

from firebase_admin import auth as firebase_auth, firestore
from fastapi import APIRouter, Depends, HTTPException
from pydantic import BaseModel

import os
import shutil
import phonenumbers

router = APIRouter(
    prefix="/auth",
    tags=["Auth"]
)

class RegistrationData(BaseModel):
    email: str
    password: str
    phone_number: str

def to_e164(phone: str, default_region: str = "KR") -> str:
    try:
        parsed_number = phonenumbers.parse(phone, default_region)
        if not phonenumbers.is_possible_number(parsed_number) or not phonenumbers.is_valid_number(parsed_number):
            raise ValueError(f"Invalid phone number: {phone}")
        return phonenumbers.format_number(parsed_number, phonenumbers.PhoneNumberFormat.E164)
    except Exception as e:
        raise ValueError(f"전화번호 변환 실패: {phone}, 에러: {str(e)}")

@router.post("/register")
async def register_user(data: RegistrationData):
    user_record = None
    user_doc_ref = None
    user_audio_dir = None
    
    try:
        e164_phone = to_e164(data.phone_number, default_region="KR")
        user_record = firebase_auth.create_user(
            email = data.email,
            password = data.password,
            phone_number = e164_phone
        )
        user_id = user_record.uid
        
        db = get_db()
        
        user_doc_ref = db.collection('users').document(user_id)
        user_doc_ref.set({
            'email': data.email,
            'phone_number': data.phone_number,
            'created_at': firestore.SERVER_TIMESTAMP,
            'is_active': True
        })
        
        base_dir = "output"
        user_audio_dir = os.path.join(base_dir, user_id, "audios")
        os.makedirs(user_audio_dir, exist_ok=True)
        
        return User(
            uid = user_record.uid,
            email = user_record.email
        )
    except Exception as e:
        if user_id and user_doc_ref is not None:
            try:
                user_doc_ref.delete()
            except Exception as firestore_del_error:
                print(f"Firestore 문서 삭제 실패: {firestore_del_error}")

        if user_record is not None:
            try:
                firebase_auth.delete_user(user_record.uid)
            except Exception as auth_del_error:
                print(f"Firebase 사용자 삭제 실패: {auth_del_error}")

        if user_audio_dir and os.path.exists(user_audio_dir):
            try:
                shutil.rmtree(os.path.join("output", user_id))
            except Exception as dir_del_error:
                print(f"디렉토리 삭제 실패: {dir_del_error}")
        raise HTTPException(status_code=400, detail=str(e))

@router.get("/current-user", response_model=User)
def get_user(user: User = Depends(get_current_user)):
    return user