import logging

from google import genai
from google.genai import types

from app.core.config import GEMINI_API_KEY
from app.prompts.analysis_prompt import ANALYSIS_PROMPT

logger = logging.getLogger(__name__)


class GeminiService:

    def __init__(self):
        logger.info("Initializing Gemini client.")
        self.client = genai.Client(api_key=GEMINI_API_KEY)
        logger.info("Gemini client initialized successfully.")

    def describe_image(self, image_bytes: bytes, mime_type: str):
        logger.info(
            "Preparing Gemini request. mime_type=%s image_size=%d bytes",
            mime_type,
            len(image_bytes),
        )

        image_part = types.Part.from_bytes(
            data=image_bytes,
            mime_type=mime_type,
        )

        logger.info("Image converted to Gemini Part.")

        logger.info("Sending request to Gemini model: gemini-flash-latest")

        response = self.client.models.generate_content(
            model="gemini-flash-latest",
            contents=[
                ANALYSIS_PROMPT,
                image_part,
            ],
        )

        logger.info("Received response from Gemini.")

        if response.text:
            logger.debug("Gemini response text: %s", response.text)
        else:
            logger.warning("Gemini response.text is empty.")

        return response.text