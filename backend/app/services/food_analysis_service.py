import json

from fastapi import UploadFile

from app.routers import analysis
from app.services.gemini_service import GeminiService

class FoodAnalysisService:

    async def analyze(self, file: UploadFile):

        image_bytes = await file.read()

        gemini = GeminiService()

        response = gemini.describe_image(
        image_bytes=image_bytes,
        mime_type=file.content_type
        )

        analysis = json.loads(response)

        return analysis