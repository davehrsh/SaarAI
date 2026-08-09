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

    logger.info("Food analysis request received.")

    try:

        logger.info(
                "Reading uploaded file. filename=%s content_type=%s",
                file.filename,
                file.content_type,
            )

        image_bytes = await file.read()

        logger.info(
                "Image read successfully. Size=%d bytes",
                len(image_bytes),
            )

        gemini = GeminiService()

        logger.info("GeminiService initialized.")
        logger.info("Sending image to Gemini for analysis.")

        response = gemini.describe_image(
            image_bytes=image_bytes,
            mime_type=file.content_type,
        )

        logger.info("Received response from Gemini.")
        logger.debug("Raw Gemini response: %s", response)

        analysis = json.loads(response)

        logger.info("Successfully parsed Gemini JSON response.")
        logger.debug("Parsed analysis: %s", analysis)

        analysis_result = AnalysisResult(**analysis)

        logger.info(
                "AnalysisResult validated successfully. is_food_product=%s health_score=%s",
                analysis_result.is_food_product,
                analysis_result.health_score,
            )

        if not analysis_result.is_food_product:
         
         logger.warning(
                    "Uploaded image is not a packaged food product."
                )
         
         raise HTTPException(
                    status_code=400,
                    detail=(
                        "No packaged food product detected. "
                        "Please upload a clear image of a packaged food product."
                    ),
                )
        
        rating = get_rating(analysis_result.health_score)

        logger.info(
                "Health rating calculated. score=%s rating=%s",
                analysis_result.health_score,
                rating,
            )

        response = AnalysisResponse(
                **analysis_result.model_dump(),
                rating=rating,
            )

        logger.info("Food analysis completed successfully.")

        return response

    except ClientError:
        logger.exception("Gemini API request failed")

        raise HTTPException(
            status_code=503,
            detail="The analysis service is temporarily unavailable. Please try again later.",
        )

    except json.JSONDecodeError:
            logger.exception("Failed to decode Gemini JSON response.")

            raise HTTPException(
                status_code=500,
                detail="Something went wrong while processing your request.",
            )

    except ValidationError:
            logger.exception("Gemini response failed Pydantic validation.")

            raise HTTPException(
                status_code=500,
                detail="Something went wrong while processing your request.",
            )

    except HTTPException as e:
            logger.warning(
                "Returning HTTPException. status_code=%d detail=%s",
                e.status_code,
                e.detail,
            )
            raise

    except Exception:
            logger.exception("Unexpected server error during food analysis.")

            raise HTTPException(
                status_code=500,
                detail="Something went wrong while processing your request.",
            )