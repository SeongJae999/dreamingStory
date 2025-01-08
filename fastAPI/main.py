# fastAPI/app/main.py
import logging

from fastapi import FastAPI, File, UploadFile
from fastapi.middleware.cors import CORSMiddleware
import shutil

from routes import auth_routes, story_routes
from utils.database import init_firebase

init_firebase()

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
    "http://10.0.2.2:8000"
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
app.include_router(story_routes.router)

@app.get("/")
def read_root():
    return {"message": "Welcome to Aiffelthon Story Generator API"}

@app.post("/upload/")
async def upload_image(file: UploadFile = File(...)):
    with open(f"uploads/{file.filename}", "wb") as buffer:
        shutil.copyfileobj(file.file, buffer)
    return {"filename": file.filename}

from fastapi.staticfiles import StaticFiles

app.mount("/uploads", StaticFiles(directory="uploads"), name="uploads")
