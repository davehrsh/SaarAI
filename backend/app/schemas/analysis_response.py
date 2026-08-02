from pydantic import BaseModel


class AnalysisResponse(BaseModel):
    product_name: str
    health_score: int
    rating: str
    summary: str