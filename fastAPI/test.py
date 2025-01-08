# 생성된 동화 -> 분할 -> 씬별 이미지 프롬프트

import openai
import os

client = openai.OpenAI(api_key=api_key)

def gpt(system_prompt, user_prompt, model="gpt-4o", temperature=0.7, max_tokens=1024):
  response = client.chat.completions.create(
    model=model,
    messages=[
        {"role": "system", "content": system_prompt},
        {"role": "user", "content": user_prompt}
    ],
    temperature=temperature,
    max_tokens=max_tokens
  )
  
  return response.choices[0].message.content

def make_image_prompt(story):

    system_prompt_for_separation =  f"""
    당신은 동화 전문가입니다.
    동화 텍스트를 읽고, 도입부, 전개부, 절정부, 결말부로 나뉜 4가지 장면으로 분할해주세요.
    """
    result = gpt(system_prompt_for_separation, story, temperature=0.2)

    system_prompt_for_image_prompt = """
    ## 역할
    당신은 FLUX.1 [dev] 모델을 활용하는 AI 이미지 생성 전문가입니다.

    ## 지시사항
    1. 주어진 장면들에 어울리는 이미지 생성 프롬프트를 작성해주세요.
    2. FLUX.1 [dev] 모델을 사용하여, 각 장면에서 필요한 주요 오브젝트 및 시각적 요소를 충분히 묘사하는 텍스트 프롬프트를 작성해야 합니다.  
    3. 출력 시에는 JSON 형식으로 scene 키를 사용하여 결과를 제시하세요.  
      - 예: 
        ```
        {
          "scene1": [첫번째 장면에 대한 묘사],
          "scene2": [두번째 장면에 대한 묘사],
          "scene3": [세번째 장면에 대한 묘사],
          "scene4": [네번째 장면에 대한 묘사],
        }
        ```
    4. 가능한 구체적인 프롬프트가 되도록, **공간(배경), 분위기, 등장인물, 색감, 스타일** 등을 세부적으로 서술하세요.  
    5. 이미지 크기는 1024x1024 또는 그 이하를 가정합니다.    
    """
    result = gpt(system_prompt_for_image_prompt, result, temperature=0.2)


    return result