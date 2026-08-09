import json
import logging

from fastapi import HTTPException, UploadFile
from google.genai.errors import ClientError
from pydantic import ValidationError

from app.schemas.analysis_result import AnalysisResult
from app.schemas.analysis_response import AnalysisResponse
from app.schemas.no_food_response import NoFoodResponse
from app.services.gemini_service import GeminiService
from app.utils.rating import get_rating

logger = logging.getLogger(__name__)

class FoodAnalysisService:

 async def analyze(self, file: UploadFile):

    try:
        image_bytes = await file.read()

        gemini = GeminiService()

        response = gemini.describe_image(
            image_bytes=image_bytes,
            mime_type=file.content_type,
        )

        analysis = json.loads(response)

        analysis_result = AnalysisResult(**analysis)

        if not analysis_result.is_food_product:
         raise HTTPException(
        status_code=400,
        detail="No packaged food product detected. Please upload a clear image of a packaged food product."
    )

        rating = get_rating(analysis_result.health_score)

        return AnalysisResponse(
            **analysis_result.model_dump(),
            rating=rating,
        )

    except ClientError:
        logger.exception("Gemini API request failed")

        raise HTTPException(
            status_code=503,
            detail="The analysis service is temporarily unavailable. Please try again later.",
        )

    except (json.JSONDecodeError, ValidationError):
        logger.exception("Invalid AI response")

        raise HTTPException(
            status_code=500,
            detail="Something went wrong while processing your request.",
        )

    except HTTPException:
     raise

    except Exception:
        logger.exception("Unexpected server error")

        raise HTTPException(
            status_code=500,
            detail="Something went wrong while processing your request.",
        )