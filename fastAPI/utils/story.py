# fastAPI/utils/story.py
from utils.config import settings
from utils.database import get_db

from firebase_admin import firestore
from langchain_anthropic import ChatAnthropic
from langchain.prompts import ChatPromptTemplate

import logging

logger = logging.getLogger(__name__)

anthropic_api_key = settings.ANTHROPIC_API_KEY

def make_chain():
    with open('/prompts/textGen_prompt.txt', 'r', encoding='utf-8') as file:
         prompt_text = file.read()

    prompt = ChatPromptTemplate.from_messages([
            ("system", prompt_text), ('human', '지금부터 동화를 생성해주세요.')
        ])
    logger.info("프롬프트가 생성되었습니다.")

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

def save_story_to_firestore(topic: str, response: str, first: str, second: str):
    db = get_db()
    doc_ref = db.collection("stories").document()

    data = {
        "topic": topic,
        "story": response,
        "selection": {
            "first": first,
            "second": second
        },
        "created_at": firestore.SERVER_TIMESTAMP
    }

    doc_ref.set(data)