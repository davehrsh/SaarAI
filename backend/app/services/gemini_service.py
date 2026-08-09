from google import genai
from google.genai import types
from app.prompts.analysis_prompt import ANALYSIS_PROMPT
from app.core.config import GEMINI_API_KEY


class GeminiService:

    def __init__(self):
        self.client = genai.Client(api_key=GEMINI_API_KEY)
    
    def describe_image(self, image_bytes: bytes, mime_type: str):

        image_part = types.Part.from_bytes(
        data=image_bytes,
        mime_type=mime_type
    )

        response = self.client.models.generate_content(
        model="gemini-flash-latest",
        contents=[ANALYSIS_PROMPT,image_part]
    )

        return response.text