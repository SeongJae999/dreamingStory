import uvicorn
from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse

from langchain_openai import ChatOpenAI
from langchain.prompts import ChatPromptTemplate
from pydantic import BaseModel

import logging
import os

from dotenv import load_dotenv
load_dotenv()
openai_api_key = os.getenv("OPENAI_API_KEY")

app = FastAPI()

origins = ["*"]
app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# 로깅 셋팅
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

def make_chain():
    prompt = ChatPromptTemplate.from_messages([
        ("system", """
         
         화자 설정 : 
         당신은 지금부터 동화를 재밌게 읽어주는 어머니입니다.
         지금부터 당신의 4세 아이에게 재미있는 창작 동화를 한국어로 들려줍니다.
         
         주제 : {topic}

         지침 :
         1) 의성어, 의태어를 풍부하게 사용해주세요.
         2) 영어는 사용하지 말아주세요.
         
         """),
    ])
    logger.info("프롬프트가 생성되었습니다.")

    llm = ChatOpenAI(openai_api_key=openai_api_key)

    chain = prompt|llm

    return chain

def generate_response(topic):
    logger.info(f"주제 : {topic}")
    
    logger.info("체인을 생성합니다.")
    chain = make_chain()
    logger.info("체인이 생성되었습니다.")

    logger.info("요청을 보냅니다.")
    response = chain.invoke({'topic':topic}).content
    logger.info("응답을 받았습니다.")

    return response

class ChatRequest(BaseModel):
    topic: str

@app.get("/")
async def root():
    logger.info('뿌리를 찾아서...')
    return "꿈꾸는 이야기"

@app.post("/generate_story")
async def generate_story(request: ChatRequest):

    try:
        response = generate_response(request.topic)
        logger.info(f"Generated response: {response}")
        response_data = {"response":response}
        return JSONResponse(content=response_data, media_type="application/json; charset=utf-8")
    
    except ValueError as ve:
        logger.error(f"ValueError occurred: {ve}")
        raise HTTPException(status_code=400, detail=str(ve))
    
    except Exception as e:
        logger.error(f"Error occurred: {e}")
        raise HTTPException(status_code=500, detail="서버에서 오류가 발생했습니다.")


if __name__ == "__main__":
    uvicorn.run(app, host="127.0.0.1", port=8000, log_level="info")