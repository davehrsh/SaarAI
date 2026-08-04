from fastapi import APIRouter, UploadFile, File
from app.schemas.analysis_response import AnalysisResponse
from app.services.food_analysis_service import FoodAnalysisService
from app.services.gemini_service import GeminiService

router = APIRouter(
    prefix="/api/v1",
    tags=["Food Analysis"]
)


@router.post("/analyze")
async def analyze(file: UploadFile = File(...)):
    service = FoodAnalysisService()
    return await service.analyze(file)