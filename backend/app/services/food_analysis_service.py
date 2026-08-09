import json

from fastapi import UploadFile

from app.schemas.analysis_result import AnalysisResult
from app.schemas.analysis_response import AnalysisResponse
from app.services.gemini_service import GeminiService
from app.utils.rating import get_rating


class FoodAnalysisService:

    async def analyze(self, file: UploadFile):

        image_bytes = await file.read()

        gemini = GeminiService()

        response = gemini.describe_image(
            image_bytes=image_bytes,
            mime_type=file.content_type
        )

        analysis = json.loads(response)

        analysis_result = AnalysisResult(**analysis)

        if not analysis_result.is_food_product:
            return analysis_result

        rating = get_rating(analysis_result.health_score)

        return AnalysisResponse(
            **analysis_result.model_dump(),
            rating=rating
        )