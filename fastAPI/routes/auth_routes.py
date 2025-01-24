# fastAPI/routes/auth_routes.py
from utils.auth import get_current_user
from utils.config import settings
from utils.database import get_db

from firebase_admin import auth as firebase_auth
from fastapi import APIRouter, Depends, HTTPException
from fastapi.security import OAuth2PasswordBearer
from pydantic import BaseModel

import datetime
import requests
import secrets

router = APIRouter(
    prefix="/auth",
    tags=["Auth"]
)

FIREBASE_API_KEY = settings.FIREBASE_API_KEY
JWT_SECRET_KEY = secrets.token_urlsafe(32)
ALGORITHM = 'HS256'
ACCESS_TOKEN_EXPIRE_MINUTES = 60

class LoginRequest(BaseModel):
    email: str
    password: str

class RegisterRequest(BaseModel):
    email: str
    password: str

class GoogleLoginRequest(BaseModel):
    id_token: str

oauth2_scheme = OAuth2PasswordBearer(tokenUrl="login")
db = get_db()

@router.post("/register")
async def register(request: RegisterRequest):
    try:
        firebase_url = f"https://identitytoolkit.googleapis.com/v1/accounts:signUp?key={FIREBASE_API_KEY}"
        payload = {
            "email": request.email,
            "password": request.password,
            "returnSecureToken": True
        }
        response = requests.post(firebase_url, json=payload)
        data = response.json()
        
        if response.status_code != 200:
            error_message = data.get('error', {}).get('message', 'Registration failed')
            raise HTTPException(status_code=400, detail=error_message)
        
        uid = data['localId']
        email = data['email']
        
        user_data = {
            "uid": uid,
            "email": email,
            "created_at": datetime.datetime.utcnow()
        }
        
        db.collection("users").document(uid).set(user_data)
        
        return {"message": "Registration successful"}
    
    except Exception as e:
        raise HTTPException(status_code=400, detail=f"Registration failed: {str(e)}")

@router.post("/login")
async def login(request: LoginRequest):
    try:
        firebase_url = f"https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key={FIREBASE_API_KEY}"

        payload = {
            "email": request.email,
            "password": request.password,
            "returnSecureToken": True
        }
        
        response = requests.post(firebase_url, json=payload)
        data = response.json()
        
        if response.status_code != 200:
            error_message = data.get('error', {}).get('message', 'Authentication failed')
            raise HTTPException(status_code=401, detail=error_message)
    
        id_token = data["idToken"]
        
        return {"id_token": id_token}

    except Exception as e:
        raise HTTPException(status_code=400, detail=f"Login failed: {str(e)}")
    
@router.post("/google_login")
async def google_login(request: GoogleLoginRequest):
    try:
        decoded_token = firebase_auth.verify_id_token(request.id_token)
        uid = decoded_token['uid']
        email = decoded_token.get('email', '')

        return {"message": f"Google login successful for {email}"}
    
    except Exception as e:
        raise HTTPException(status_code=400, detail=f"Google login failed: {str(e)}")

@router.post("/anonymous_login")
async def anonymous_login():
    try:
        user_record = firebase_auth.create_user(
            email=None,
            email_verified=False,
            disabled=False
        )

        return {"message": f"Anonymous user created with UID: {user_record.uid}"}

    except Exception as e:
        raise HTTPException(status_code=400, detail=f"Anonymous login failed: {str(e)}")
    
@router.get("/protected")
async def protected_route(user: dict = Depends(get_current_user)):
    return {"message": f"Hello, {user.email}!"}