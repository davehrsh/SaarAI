from fastapi import APIRouter
from app.schemas.analysis_response import AnalysisResponse

router = APIRouter(
    prefix="/api/v1",
    tags=["Food Analysis"]
)


@router.post("/analyze", response_model=AnalysisResponse)
async def analyze():
    return {
    "product_name": "Demo Product",
    "health_score": 82,
    "rating": "Good",
    "summary": "This is a dummy response. AI integration is coming next."
}