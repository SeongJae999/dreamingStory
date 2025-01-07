import uvicorn
from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse

from langchain_openai import ChatOpenAI
from langchain_anthropic import ChatAnthropic
from langchain.prompts import ChatPromptTemplate
from pydantic import BaseModel

from API.api import sd_generate_image_v1, gpt_generate_text

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
    # with open('dreamingStory/fastAPI/prompt.txt', 'r', encoding='utf-8') as file:
    #     prompt_text = file.read()

    prompt_text = """## 화자 설정 :
당신은 4세 아이를 위해 동화를 들려주는 따뜻하고 친근한 어머니입니다.
부드러운 목소리와 감정을 담아 이야기를 전달합니다.
아이의 상상력을 자극할 수 있도록 표현합니다.

## 스토리 구성 요소:
1. 서술 방식
    - 의성어, 의태어를 풍부하게 사용해주세요.
    - 한글을 사용해주세요.
    - 짧고 단순한 문장으로 구성
    - 아이들의 눈높이에 맞는 쉬운 단어 선택

2. 주제
    - {topic}

3. 이야기 구조
    - 도입부: 주인공과 배경 소개
    - 전개부: 문제 상황 발생
    - 절정부: 고민이나 갈등 상황
    - 선택부: 두 가지 흥미로운 선택지 제시

## 지시사항
1. 서술 규칙
    - 전체 이야기는 3~4분 안에 읽을 수 있는 길이로 구성
    - 각 문장은 15단어를 넘지 않도록 제한
    - 이야기는 반드시 선택지 자체로 종료할 것
    - 선택지 뒤로 어떠한 질문이나 멘트도 포함하지 않을 것

2. 교육적 요소 강화
    - 주제와 관련된 긍정적인 표현을 3회 이상 포함
    - 부정적인 결과는 위협적이지 않게 표현
    - 선택지는 모두 긍정적인 방향으로 구성

3. 상호작용 요소
    - 이야기 중간에 아이가 따라 할 수 있는 동작 포함
    - 선택지 제시 전에 아이의 생각을 물어보는 질문 포함
    - 엄마와 아이가 함께 이야기를 발전시킬 수 있는 요소 포함

## 예시:
    [본문 이야기]

    "자, 우리 oo는 어떻게 하면 좋을까요?
        [1] [첫 번째 선택지]
        [2] [두 번째 선택지]     """
    
    logger.info(f"프롬프트 텍스트 파일: \n {prompt_text}")

    prompt = ChatPromptTemplate.from_messages([
            ("system", prompt_text), ('human', '지금부터 동화를 생성해주세요.')
        ])
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

class ImageRequest(BaseModel):
    prompt: str

@app.get("/")
async def root():

    logger.info('뿌리를 찾아서...')
    return "꿈꾸는 이야기"

@app.post("/generate_story")
async def generate_story(request: ChatRequest):

    try:
        response = generate_response(request.topic)
        logger.info(f"Generated response: {response}")
        first = response.split('[1]')[1].split('[2]')[0].strip()
        second = response.split('[2]')[1].strip()
        response = response.split('[1]')[0].strip()
        response_data = {"response":response, "selection" : {'first' : first, 'second' : second}}
        return JSONResponse(content=response_data, media_type="application/json; charset=utf-8")
    
    except ValueError as ve:
        logger.error(f"ValueError occurred: {ve}")
        raise HTTPException(status_code=400, detail=str(ve))
    
    except Exception as e:
        logger.error(f"Error occurred: {e}")
        raise HTTPException(status_code=500, detail="서버에서 오류가 발생했습니다.")
    
@app.post("/generate_image")
async def generate_image(request: ImageRequest):

    try:
        # prompt = f"""
        # translate the korean text delimited by triple backticks in English.
        # ```{request.prompt}```
        # """
        # eng_prompt = gpt_generate_text(prompt)
        # image_path = sd_generate_image_v1(eng_prompt) 
        image_path = "C:/project/github/250107_1712/dreamingStory/fastAPI/output/images/20250107_122402.png"
        return JSONResponse(content=image_path, media_type="application/json; charset=utf-8")
    
    except ValueError as ve:
        logger.error(f"ValueError occurred: {ve}")
        raise HTTPException(status_code=400, detail=str(ve))
    
    except Exception as e:
        logger.error(f"Error occurred: {e}")
        raise HTTPException(status_code=500, detail="서버에서 오류가 발생했습니다.")


if __name__ == "__main__":
    uvicorn.run(app, host="127.0.0.1", port=8000, log_level="info")