import logging

from fastapi import APIRouter, File, HTTPException, UploadFile

from app.schemas.analysis_response import AnalysisResponse
from app.services.food_analysis_service import FoodAnalysisService

logger = logging.getLogger(__name__)

router = APIRouter(
    prefix="/api/v1",
    tags=["Food Analysis"],
)

ALLOWED_IMAGE_TYPES = {
    "image/jpeg",
    "image/jpg",
    "image/png",
    "image/webp",
}


@router.post(
    "/analyze",
    response_model=AnalysisResponse,
)
async def analyze(files: list[UploadFile] = File(...)):

    logger.info(
        "Received /analyze request with %d image(s).",
        len(files),
    )

    if len(files) > 3:
        logger.warning(
            "Rejected upload because %d images were provided.",
            len(files),
        )

        raise HTTPException(
            status_code=400,
            detail="You can upload a maximum of 3 images.",
        )

    for file in files:

        if file.content_type not in ALLOWED_IMAGE_TYPES:
            logger.warning(
                "Rejected upload due to unsupported media type. filename=%s content_type=%s",
                file.filename,
                file.content_type,
            )

            raise HTTPException(
                status_code=400,
                detail="Unsupported image format. Please upload a JPG, JPEG or PNG image.",
            )

    logger.info("Upload validation passed.")

    service = FoodAnalysisService()

    logger.info("Calling FoodAnalysisService.analyze().")

    result = await service.analyze(files)

    logger.info("Food analysis request completed successfully.")

    return result