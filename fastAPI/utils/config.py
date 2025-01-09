# fastAPI/app/utils/config.py
import os
from dotenv import load_dotenv
from pathlib import Path

# .env 파일 경로 설정
BASE_DIR = Path(__file__).resolve().parent.parent
dotenv_path = BASE_DIR / ".env"

# 환경 변수 로드
load_dotenv(dotenv_path=dotenv_path)

class Settings:
    FIREBASE_CREDENTIALS: str = os.getenv("FIREBASE_CREDENTIALS")
    ANTHROPIC_API_KEY: str = os.getenv("ANTHROPIC_API_KEY")
    
settings = Settings()
