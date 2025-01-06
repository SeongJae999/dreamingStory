import uvicorn
from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse

from langchain_openai import ChatOpenAI
from langchain_anthropic import ChatAnthropic
from langchain.prompts import ChatPromptTemplate
from pydantic import BaseModel

import logging
import os

from dotenv import load_dotenv
load_dotenv()
# openai_api_key = os.getenv("OPENAI_API_KEY")
anthropic_api_key = os.getenv("ANTHROPIC_API_KEY")

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
<<<<<<< HEAD
    with open('dreamingStory/fastAPI/prompt.txt', 'r', encoding='utf-8') as file:
        prompt_text = file.read()
        logger.info(f"프롬프트 텍스트 파일: \n {prompt_text}")

    prompt = ChatPromptTemplate.from_messages([
            ("system", prompt_text), ('human', '지금부터 동화를 생성해주세요.')
        ])
=======
    # prompt = ChatPromptTemplate.from_messages([
    #     ("system", """
         
    #      화자 설정 : 
    #      당신은 지금부터 동화를 재밌게 읽어주는 어머니입니다.
    #      지금부터 당신의 4세 아이에게 재미있는 창작 동화를 한국어로 들려줍니다.
         
    #      주제 : {topic}

    #      지침 :
    #      1) 의성어, 의태어를 풍부하게 사용해주세요.
    #      2) 영어는 사용하지 말아주세요.
         
    #      """),
    # ])
    prompt = ChatPromptTemplate.from_messages([
        ("system", """
            ## 화자 설정 : 
                당신은 지금부터 동화를 재밌게 읽어주는 어머니입니다.
                지금부터 당신의 4세 아이에게 재미있는 창작 동화를 한국어로 들려줍니다.
         
            ## 지시: 
                - 의성어, 의태어를 풍부하게 사용해주세요.
                - 한글을 사용해주세요.
                - 아래 Triple backticks로 감싸진 '주제'의 교훈을 담은 이야기를 만들어주세요.
            
                    ```'주제' : {topic}```
         
                - 이야기를 결말을 만들지 말고 두 가지 선택지를 주어 이야기를 이어갈 수 있게 해주세요.
                    예시:
                    1. 
                    [1] 붕붕~ 자동차를 타고 갈까요? 
                    [2] 엄마 아빠가 기다리는 집으로 뛰어갈까요?
                    
                    2. 
                    [1] 용감한 마음을 가져서 숲 속을 계속 탐험해볼까요?
                    [2] 곰에게 도움을 요청하고 마을로 돌아갈까요?
 
         """)
    ])
>>>>>>> b55fb5088c81768ba9cdff39ab8ae7da0846e5e0
    logger.info("프롬프트가 생성되었습니다.")

    # llm = ChatOpenAI(openai_api_key=openai_api_key,
    #                  model='gpt-4o',
    #                  temperature=0.7,
    #                  max_tokens=512)

    llm = ChatAnthropic(api_key=anthropic_api_key,
                        model="claude-3-5-sonnet-20240620",
                        temperature=0.7,
                        max_tokens=1024)

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
        first = response.split('[1]')[1].split('?')[0].strip()
        second = response.split('[2]')[1].strip()
        logger.info(f"Generated response: {response}")
<<<<<<< HEAD
        first = response.split('[1]')[1].split('[2]')[0].strip()
        second = response.split('[2]')[1].strip()
        response = response.split('[1]')[0].strip()
=======
        response = response.split('---')[0].strip()
>>>>>>> b55fb5088c81768ba9cdff39ab8ae7da0846e5e0
        response_data = {"response":response, "selection" : {'first' : first, 'second' : second}}
        return JSONResponse(content=response_data, media_type="application/json; charset=utf-8")
    
    except ValueError as ve:
        logger.error(f"ValueError occurred: {ve}")
        raise HTTPException(status_code=400, detail=str(ve))
    
    except Exception as e:
        logger.error(f"Error occurred: {e}")
        raise HTTPException(status_code=500, detail="서버에서 오류가 발생했습니다.")


if __name__ == "__main__":
    uvicorn.run(app, host="127.0.0.1", port=8000, log_level="info")