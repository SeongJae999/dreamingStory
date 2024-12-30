# fastAPI/app/main.py
import logging

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from routes import auth_routes, story_routes
from utils.config import settings


# 로깅 설정
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# FastAPI 인스턴스 생성
app = FastAPI(
    title="Aiffelthon Story Generator API",
    description="An API for generating stories with images and audio",
    version="1.0.0"
)

# CORS 설정
origins = [
    "http://localhost",
    "http://localhost:3000",
    "https://your-frontend-domain.com",
]

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# 라우트 포함
app.include_router(auth_routes.router)
# app.include_router(story_routes.router)

# 기본 엔드포인트
@app.get("/")
def read_root():
    return {"message": "Welcome to Aiffelthon Story Generator API"}
