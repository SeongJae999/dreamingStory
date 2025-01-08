import os
from google.cloud import texttospeech

os.environ['GOOGLE_APPLICATION_CREDENTIALS'] = 'demo_service_account.json'
client = texttospeech.TextToSpeechClient()


text_block = '''
작은 마을의 용감한 강아지

옛날 옛적에, 아주 작은 마을에 쪼꼬라는 귀여운 강아지가 살았어요.
쪼꼬는 깡충깡충 뛰어다니며 마을 구석구석을 돌아다니는 것을 좋아했답니다.

"멍멍! 안녕하세요!"
쪼꼬는 매일 아침 이웃들에게 인사를 했어요.
(자, 우리도 같이 멍멍! 하면서 인사해볼까요?)

어느 날, 마을에 커다란 호랑이가 나타났어요.
쿵쿵쿵! 호랑이의 발소리가 마을 전체에 울렸답니다.
(우리도 같이 쿵쿵쿵! 발을 구르며 호랑이처럼 해볼까요?)

마을 사람들은 모두 무서워서 집 안에 숨어버렸어요.
하지만 쪼꼬는 용기를 내어 호랑이 앞에 섰답니다.

"안녕하세요, 호랑이님! 우리 마을에 온 걸 환영해요!"
쪼꼬의 따뜻한 인사에 호랑이는 깜짝 놀랐어요.

호랑이는 실은 길을 잃어버려서 배가 고팠던 거예요.
마을 사람들이 모두 숨어버려서 도움을 청할 수도 없었답니다.

쪼꼬는 생각에 빠졌어요.
"음... 호랑이님을 어떻게 도와드리면 좋을까요?"

'''

synthesis_input = texttospeech.SynthesisInput(text=text_block)

voice = texttospeech.VoiceSelectionParams(
        language_code='ko-KR',
        name='ko-KR-Standard-D'
)

audio_config = texttospeech.AudioConfig(
    audio_encoding=texttospeech.AudioEncoding.MP3,
    # effects_profile_id=['small-bluetooth-speaker-class-device']
    speaking_rate=0.8,
    pitch=1
)

response = client.synthesize_speech(
        input=synthesis_input, 
        voice=voice, 
        audio_config=audio_config
)

with open("output3.mp3", "wb") as output:
    output.write(response.audio_content)
    print('Audio content written to file "output3.mp3"')