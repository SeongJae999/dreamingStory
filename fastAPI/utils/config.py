# fastAPI/app/utils/config.py
import os
from dotenv import load_dotenv
from pathlib import Path

BASE_DIR = Path(__file__).resolve().parent.parent
dotenv_path = BASE_DIR / ".env"

load_dotenv(dotenv_path=dotenv_path)

class Settings:
    FIREBASE_CREDENTIALS: str = os.getenv("FIREBASE_CREDENTIALS")
    GOOGLE_APPLICATION_CREDENTIALS: str = os.getenv("GOOGLE_APPLICATION_CREDENTIALS")
    ANTHROPIC_API_KEY: str = os.getenv("ANTHROPIC_API_KEY")
    OPENAI_API_KEY: str = os.getenv("OPENAI_API_KEY")
    NGROK_URL: str = os.getenv("NGROK_URL")
    JWT_SECERT_KEY: str = os.getenv("JWT_SECRET_KEY")
    FIREBASE_API_KEY: str = os.getenv("FIREBASE_API_KEY")
    
settings = Settings()