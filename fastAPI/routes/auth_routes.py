# fastAPI/routes/auth_routes.py
from utils.auth import get_current_user
from utils.database import get_db
from models.user import User

from firebase_admin import auth as firebase_auth, firestore
from fastapi import APIRouter, Depends, HTTPException
from pydantic import BaseModel

import os
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
    try:
        e164_phone = to_e164(data.phone_number, default_region="KR")
        user_record = firebase_auth.create_user(
            email = data.email,
            password = data.password,
            phone_number = e164_phone
        )
        user_id = user_record.uid
        
        db = get_db()
        
        db.collection('users').document(user_id).set({
            'email': data.email,
            'phone_number': data.phone_number,
            'created_at': firestore.SERVER_TIMESTAMP,
            'is_active': True
        })
        
        base_dir = "output"
        user_audio_dir = os.path.join(base_dir, user_id, "audios")
        os.mkdir(user_audio_dir, exist_ok=True)
        
        return User(
            uid = user_record.uid,
            email = user_record.email
        )
    except Exception as e:
        raise HTTPException(status_code=400, detail=str(e))

@router.get("/current-user", response_model=User)
def get_user(user: User = Depends(get_current_user)):
    return user