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

    def describe_images(self, images: list[dict]):

        logger.info(
            "Preparing Gemini request with %d image(s).",
            len(images),
        )

        contents = [ANALYSIS_PROMPT]

        for index, image in enumerate(images, start=1):

            logger.info(
                "Converting image %d to Gemini Part. mime_type=%s size=%d bytes",
                index,
                image["mime_type"],
                len(image["bytes"]),
            )

            contents.append(
                types.Part.from_bytes(
                    data=image["bytes"],
                    mime_type=image["mime_type"],
                )
            )

        logger.info("Sending request to Gemini model: gemini-flash-latest")

        response = self.client.models.generate_content(
            model="gemini-flash-latest",
            contents=contents,
        )

        logger.info("Received response from Gemini.")

        if response.text:
            logger.debug("Gemini response text: %s", response.text)
        else:
            logger.warning("Gemini response.text is empty.")

        return response.text