from fastapi import APIRouter, File, HTTPException, UploadFile
from app.schemas.analysis_response import AnalysisResponse
from app.schemas.no_food_response import NoFoodResponse
from app.services.food_analysis_service import FoodAnalysisService

router = APIRouter(
    prefix="/api/v1",
    tags=["Food Analysis"]
)

ALLOWED_IMAGE_TYPES = {
    "image/jpeg",
    "image/jpg",
    "image/png",
    "image/webp"
}

@router.post("/analyze",response_model=AnalysisResponse | NoFoodResponse)
async def analyze(file: UploadFile = File(...)):
    if file.content_type not in ALLOWED_IMAGE_TYPES:
        raise HTTPException(
            status_code=400,
            detail="Unsupported media format. Please upload a JPG, JPEG or PNG image.",
        )

    service = FoodAnalysisService()

    return await service.analyze(file)