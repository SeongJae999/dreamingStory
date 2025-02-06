🦄 AI 창작동화: 꿈꾸는 이야기에 오신 것을 환영합니다 🦄
====================
<br>

📝 꿈꾸는 이야기란? 📝
---------------------
<div align="center">
  <img src="flutter/assets/images/app_icon.png" alt="앱 아이콘" width="100">
  
### 꿈꾸는 이야기는 만 4~6세의 미취학 아동을 위한 
### 생성형 AI를 활용한 창작동화 애플리케이션입니다.
<br> 

#### 버튼식 프롬프트 구조를 활용하여
#### 글을 모르는 아이들도 직접 원하는 동화를 창작할 수 있으며
#### 보호자가 원하는 교훈을 담은 동화를 생성해낼 수 있습니다.
</div>

<br>


👬👨🏻‍💻 전래좋군 소개 👨🏻‍💻👬
---------------------
| Members | Roles | Responsibilities |
|:--|:--|:--|
|조정민([@SeongJae999](https://github.com/SeongJae999)) <br>skanehfud279@gmail.com|Team Leader, Back-end Engineer |- Server and database management <br>- Google Cloud Platform (GCP) administration <br>|
|김민규([@incheonQ](https://github.com/incheonQ)) <br>logisdatascience@gmail.com |Front-end developer  |- UI/UX design and implementation <br>- Troubleshooting and debugging|
|이동수([@Lee-Dongsu](https://github.com/Lee-Dongsu)) <br>ehdtnehdtn95@naver.com |AI, NLP, Prompt Engineer    |- Prompt design and AI model experimentation <br>- QA, User, and Mobile service testing|
|김우찬([@chanxxw](https://github.com/chanxxw)) <br>strauss2327@gmail.com |Project Manager, Prompt Engineer  |- Strategic planning, research and marketing <br>- Image prompt engineering|

<br>

🤖 서비스 소개 🤖
---------------------
1. 꿈꾸는 이야기 개요
- 이 앱이 무엇을 하는지 한 문장으로 정리

  
2. 기본 기능 : 동화 텍스트, 삽화 이미지, TTS 서비스를 동시에 적용하여 창작동화 구현 
    
3. 꿈꾸는 이야기의 특장점
  - 버튼식 프롬프트 구조를 통해 글을 모르는 미취학 아동도 동화 생성에 참여할 수 있습니다.
  - 보호자가 원하는 교훈(ex. 양치질을 잘해요)을 동화에 녹아내어 아이들의 사회적 규칙을 배우는 데에 도움을 줍니다.
 
  
#### 자세한 내용을 알고 싶다면 추후 추가 될 유튜브 영상을 참고해주세요! (3월 예정)

<br>

🗺️ 프로세스 맵 🗺️
---------------------
사용자가 앱을 사용하면서 거치는 단계 (User Flow)
예를 들어:
온보딩 → 2. 버튼 선택 → 3. 동화 생성 → 4. 이미지 생성 → 5. 오디오 변환
추천 이미지: 서비스 흐름을 보여주는 다이어그램

화면 캡쳐본으로 PPT로 만들어볼까?

<br>

Tech Stack
---------------------
### 🏗️ Core Technologies
- **Fairy Tale Text Generation:** Claude 3.5 Sonnet
- **Image Generation:**
  - GPT-4o-mini - 프롬프트 텍스트 생성 모델
  - FLUX.1-Schnell - 이미지 생성 모델
- **TTS (Text-to-Speech):** Google Cloud Speech API 2.0  

### 📱 Frontend
- **Flutter** – 모바일 UI 개발  
- **Cursor.ai** – 개발 도구  

### 🖥️ Backend & Infrastructure
- **FastAPI** – API 개발  
- **Firebase** – 데이터 관리  
- **Google Cloud Platform (GCP)** – 클라우드 서비스  
- **Ngrok** – 터널링 서비스  

### 🧠 AI & Model Training
- **LangChain** – AI 모델 연결  
- **LoRA (Low-Rank Adaptation)** – 이미지 경량 모델 튜닝
- **ComfyUI** - Text-to-Image model 위한 노드 기반 GUI
 
<br>

 
🏛️ Architecture 🏛️
---------------------
- 전체 시스템 구조를 다이어그램으로 표현
- 사용자가 요청 → AI 모델 → 데이터 처리 → 최종 결과 출력 흐름을 설명
<br>


📚 시연 영상 및 발표자료 📚
---------------------
- gif로 올리기
1. 온보딩
2. 나만의 동화 만들기
3. 무료 동화
4. 발표 자료(유튜브 링크)
- 자세한 내용은 유튜브를 참고해 주세요
- 유튜브 링크
<br>

🌲 Project Tree 🎄
---------------------
- 프로젝트 폴더 구조 정리
<br>

🪪 Usage & License 🪪
---------------------
- 앱 사용 방식 설명
- API 기반 서비스라면 API 엔드포인트 정보 포함

1. 이미지 생성 : FLUX  
<sub>  - The FLUX.1 [dev] Model is licensed by Black Forest Labs. Inc. under the FLUX.1 [dev] Non-Commercial License. Copyright Black Forest Labs. Inc. </sub>  
<sub>  - IN NO EVENT SHALL BLACK FOREST LABS, INC. BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH USE OF THIS MODEL. </sub>
2. 배경 음악 : Created with Suno AI
3. 아이콘 : Icons by Icons8
<br>

Reference
---------------------
- PPT 정리 후 올리기
<br>

Acknowledgements
---------------------
이번 프로젝트를 위해 아낌없는 도움을 주신 분들께 진심으로 감사드립니다.  

- **[@전효정](https://www.linkedin.com/in/%ED%9A%A8%EC%A0%95-%EC%A0%84-11b8b2179/)** – AIFFELthon Project Manager 🏆  
- **[@조새벽](https://www.linkedin.com/in/chochoq/)** – Flutter Mentor 📱  
- **[@오근철](https://www.linkedin.com/in/gchrisoh/)** – Modeling Mentor 🤖    

여러분의 지원과 도움 덕분에 프로젝트를 성공적으로 마칠 수 있었습니다.  
진심으로 감사드립니다! 🙌  
<br>

---
이 프로젝트는 [모두의연구소](https://modulabs.co.kr/) **아이펠 코어 9기** 과정에서 진행된 **아이펠톤**에서 탄생했으며, **전래좋군 팀**이 기획하고 개발을 주도하였습니다.






끝
----------------------


A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.




끝
----------------------


A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
