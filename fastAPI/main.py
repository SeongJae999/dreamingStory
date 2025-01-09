# fastAPI/app/main.py
from routes import auth_routes, story_routes
from utils.database import init_firebase

from fastapi import FastAPI, File, UploadFile
from fastapi.middleware.cors import CORSMiddleware

import shutil
import logging
import uvicorn

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

init_firebase()

app = FastAPI(
    title="Aiffelthon Story Generator API",
    description="An API for generating stories with images and audio",
    version="1.0.0"
)

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

app.include_router(auth_routes.router)
app.include_router(story_routes.router)

@app.get("/")
def read_root():
    logger.info('뿌리를 찾아서...')
    return {"message": "Welcome to Aiffelthon Story Generator API"}

@app.post("/upload/")
async def upload_image(file: UploadFile = File(...)):
    with open(f"uploads/{file.filename}", "wb") as buffer:
        shutil.copyfileobj(file.file, buffer)
    return {"filename": file.filename}

from fastapi.staticfiles import StaticFiles

app.mount("/uploads", StaticFiles(directory="uploads"), name="uploads")

if __name__ == "__main__":
    uvicorn.run(app, host="127.0.0.1", port=8000, log_level="info")