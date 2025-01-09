from google.cloud import texttospeech
from utils.config import settings

import logging
import re
import os

logger = logging.getLogger(__name__)

tts_client = texttospeech.TextToSpeechClient()

def synthesize_speech_to_file(text: str, output_filename: str = "output.mp3"):
    cleaned_text = re.sub(r'\(.*?\)', '', text)

    paragraphs = cleaned_text.strip().split('\n\n')
    ssml_paragraphs = []
    for paragraph in paragraphs:
        sentences = re.split(r'(?<=\.)\s+', paragraph.strip())
        ssml_paragraph = ' <break time="1000ms"/> '.join(sentences)
        ssml_paragraphs.append(ssml_paragraph)

    ssml_text = '<speak>' + ' <break time="2000ms"/> '.join(ssml_paragraphs) + '</speak>'

    synthesis_input = texttospeech.SynthesisInput(ssml=ssml_text)

    voice_params = texttospeech.VoiceSelectionParams(
        language_code='ko-KR',
        name='ko-KR-Standard-D'
    )

    audio_config = texttospeech.AudioConfig(
        audio_encoding=texttospeech.AudioEncoding.MP3,
        speaking_rate=0.8,
        pitch=1
    )

    response = tts_client.synthesize_speech(
        input=synthesis_input,
        voice=voice_params,
        audio_config=audio_config
    )

    output_path = os.path.join('./output/audios', output_filename)
    
    with open(output_path, "wb") as out:
        out.write(response.audio_content)
        print(f'Audio content written to file "{output_filename}"')