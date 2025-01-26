# fastAPI/app/main.py
import os
os.environ['KMP_DUPLICATE_LIB_OK']='TRUE'

from routes import auth_routes, story_routes
from utils.database import init_firebase

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from fastapi.staticfiles import StaticFiles

import logging
import uvicorn
import os

logger = logging.getLogger("myapp")
logger.setLevel(logging.DEBUG)

init_firebase()

app = FastAPI(
    title="Aiffelthon Story Generator API",
    description="An API for generating stories with images and audio",
    version="1.0.0"
)

origins = [
    "http://10.0.2.2:8000",
    "http://localhost",
    "http://localhost:3000",
    os.getenv('NGROK_URL'),
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

app.mount("/output", StaticFiles(directory="output"), name="output")

if __name__ == "__main__":
    uvicorn.run("main:app", host="127.0.0.1", port=8000, log_level="debug", access_log=True)